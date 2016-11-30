//
//  YYClassInfo.m
//  YYModel <https://github.com/ibireme/YYModel>
//
//  Created by ibireme on 15/5/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYClassInfo.h"
#import <objc/runtime.h>

//@encode
//把typeEncoding转变为自定义的枚举类型 ，方便管理使用
YYEncodingType YYEncodingGetType(const char *typeEncoding) {
    //判断传入值  是nil、空则返回 YYEncodingTypeUnknown
    //转换 const 限定符
    char *type = (char *)typeEncoding;
    if (!type) return YYEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return YYEncodingTypeUnknown;
    
    
    //找出修饰语 Objective-C method encodings
    
    YYEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {//  位运算标志数据
                qualifier |= YYEncodingTypeQualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= YYEncodingTypeQualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= YYEncodingTypeQualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= YYEncodingTypeQualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= YYEncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= YYEncodingTypeQualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= YYEncodingTypeQualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }

    //是否还存在后续的字符,如果是0 就没必要继续查找类型了
    len = strlen(type);
    if (len == 0) return YYEncodingTypeUnknown | qualifier;

    //查找数据类型
    switch (*type) {
        case 'v': return YYEncodingTypeVoid | qualifier;
        case 'B': return YYEncodingTypeBool | qualifier;
        case 'c': return YYEncodingTypeInt8 | qualifier;
        case 'C': return YYEncodingTypeUInt8 | qualifier;
        case 's': return YYEncodingTypeInt16 | qualifier;
        case 'S': return YYEncodingTypeUInt16 | qualifier;
        case 'i': return YYEncodingTypeInt32 | qualifier;
        case 'I': return YYEncodingTypeUInt32 | qualifier;
        case 'l': return YYEncodingTypeInt32 | qualifier;
        case 'L': return YYEncodingTypeUInt32 | qualifier;
        case 'q': return YYEncodingTypeInt64 | qualifier;
        case 'Q': return YYEncodingTypeUInt64 | qualifier;
        case 'f': return YYEncodingTypeFloat | qualifier;
        case 'd': return YYEncodingTypeDouble | qualifier;
        case 'D': return YYEncodingTypeLongDouble | qualifier;
        case '#': return YYEncodingTypeClass | qualifier;
        case ':': return YYEncodingTypeSEL | qualifier;
        case '*': return YYEncodingTypeCString | qualifier;
        case '^': return YYEncodingTypePointer | qualifier;
        case '[': return YYEncodingTypeCArray | qualifier;
        case '(': return YYEncodingTypeUnion | qualifier;
        case '{': return YYEncodingTypeStruct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return YYEncodingTypeBlock | qualifier;
            else
                return YYEncodingTypeObject | qualifier;
        }
        default: return YYEncodingTypeUnknown | qualifier;
    }
}

@implementation YYClassIvarInfo

- (instancetype)initWithIvar:(Ivar)ivar {
    // 判断是否为空
    if (!ivar) return nil;
    self = [super init];
    _ivar = ivar;
    //获取ivar的名字
    const char *name = ivar_getName(ivar);
    if (name) {
        // 把c的字符串转化成oc的字符串
        _name = [NSString stringWithUTF8String:name];
   }
   //获取相对偏移量，增加命中率？
    _offset = ivar_getOffset(ivar);
    const char *typeEncoding = ivar_getTypeEncoding(ivar);
    if (typeEncoding) {//获得编码并转换为YYType
        //转换成NSSring
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        //枚举值 YYType类型
        _type = YYEncodingGetType(typeEncoding);
    }
    return self;
}

@end

@implementation YYClassMethodInfo

- (instancetype)initWithMethod:(Method)method {
    
    //方法的合法性
    if (!method) return nil;
    self = [super init];
    _method = method;
    //取得的SEL 方法名
    _sel = method_getName(method);
    //取得的IMP 方法的地址
    _imp = method_getImplementation(method);
    const char *name = sel_getName(_sel);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    //取得Method对应的类型
    const char *typeEncoding = method_getTypeEncoding(method);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
    }
    //取得返回内容的类型
    char *returnType = method_copyReturnType(method);
    if (returnType) {
        _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
        // 但凡 通过copy retain alloc 系统方法得到的内存，必须使用relea() 或 free() 进行释放

        free(returnType);
    }
    //循环取得一个方法的参数 并且取得每一个参数类型，加入到数组中
    unsigned int argumentCount = method_getNumberOfArguments(method);
    if (argumentCount > 0) {
        NSMutableArray *argumentTypes = [NSMutableArray new];
        for (unsigned int i = 0; i < argumentCount; i++) {
            //取得某一个参数
            char *argumentType = method_copyArgumentType(method, i);
            NSString *type = argumentType ? [NSString stringWithUTF8String:argumentType] : nil;
            [argumentTypes addObject:type ? type : @""];
            if (argumentType) free(argumentType);
        }
        _argumentTypeEncodings = argumentTypes;
    }
    return self;
}

@end

@implementation YYClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    //属性的合法
    if (!property) return nil;
    self = [self init];
    _property = property;
    //1。获取属性名称
    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    // 2. 获取每一个属性的编码字符串
    YYEncodingType type = 0;
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    // 3. 编译每一个属性的 objc_property_attribute_t
    for (unsigned int i = 0; i < attrCount; i++) {
        // 3.1 根据 objc_property_attribute_t 中的 name 做一些事
        switch (attrs[i].name[0]) {
                // T代码属性的类型编码
            case 'T': { // Type encoding
            
                if (attrs[i].value) {
                    _typeEncoding = [NSString stringWithUTF8String:attrs[i].value];
                    type = YYEncodingGetType(attrs[i].value);
                    //计算属性的实体类型  如 @"YYer"  name = T , value = @"YYer"
                    if ((type & YYEncodingTypeMask) == YYEncodingTypeObject) {
                        size_t len = strlen(attrs[i].value);//7
                        if (len > 3) {
                            char name[len - 2]; //一个长度为5的字符数据 [len -2]
                            name[len - 3] = '\0';//最后一个字符为\0
                            memcpy(name, attrs[i].value + 2, len - 3);
                            //获得name真实实体类型
                            _cls = objc_getClass(name);
                        }
                    }
                }
            } break;
            case 'V': { // Instance variable
                if (attrs[i].value) {
                    _ivarName = [NSString stringWithUTF8String:attrs[i].value];
                }
            } break;
            case 'R': {
                type |= YYEncodingTypePropertyReadonly;
            } break;
            case 'C': {
                type |= YYEncodingTypePropertyCopy;
            } break;
            case '&': {
                type |= YYEncodingTypePropertyRetain;
            } break;
            case 'N': {
                type |= YYEncodingTypePropertyNonatomic;
            } break;
            case 'D': {
                type |= YYEncodingTypePropertyDynamic;
            } break;
            case 'W': {
                type |= YYEncodingTypePropertyWeak;
            } break;
            case 'G': {
                //Get方法
                type |= YYEncodingTypePropertyCustomGetter;
                if (attrs[i].value) {
                    _getter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            } break;
            case 'S': {
                //Set方法
                type |= YYEncodingTypePropertyCustomSetter;
                if (attrs[i].value) {
                    _setter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            } // break; commented for code coverage in next line
            default: break;
        }
    }
    if (attrs) {
        free(attrs);
        attrs = NULL;
    }
    
    _type = type;
    //获取set get 的方法
    if (_name.length) {
        if (!_getter) {
            _getter = NSSelectorFromString(_name);
        }
        if (!_setter) {
            _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]]);
        }
    }
    return self;
}

@end

@implementation YYClassInfo {
    BOOL _needUpdate;
}

- (instancetype)initWithClass:(Class)cls {
    if (!cls) return nil;
    self = [super init];
    _cls = cls;
    _superCls = class_getSuperclass(cls);
    _isMeta = class_isMetaClass(cls);
    if (!_isMeta) {
        _metaCls = objc_getMetaClass(class_getName(cls));
    }
    // 获得类名
    _name = NSStringFromClass(cls);
    [self _update];
    
    // 获得_superInfo
    _superClassInfo = [self.class classInfoWithClass:_superCls];
    return self;
}

- (void)_update {
    _ivarInfos = nil;
    _methodInfos = nil;
    _propertyInfos = nil;
    
    Class cls = self.cls;
    //几个类似的方法
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    if (methods) {
        NSMutableDictionary *methodInfos = [NSMutableDictionary new];
        _methodInfos = methodInfos;
        for (unsigned int i = 0; i < methodCount; i++) {
            YYClassMethodInfo *info = [[YYClassMethodInfo alloc] initWithMethod:methods[i]];
            if (info.name) methodInfos[info.name] = info;
        }
        free(methods);
    }
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    if (properties) {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        _propertyInfos = propertyInfos;
        for (unsigned int i = 0; i < propertyCount; i++) {
            YYClassPropertyInfo *info = [[YYClassPropertyInfo alloc] initWithProperty:properties[i]];
            if (info.name) propertyInfos[info.name] = info;
        }
        free(properties);
    }
    
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarCount);
    if (ivars) {
        NSMutableDictionary *ivarInfos = [NSMutableDictionary new];
        _ivarInfos = ivarInfos;
        for (unsigned int i = 0; i < ivarCount; i++) {
            YYClassIvarInfo *info = [[YYClassIvarInfo alloc] initWithIvar:ivars[i]];
            if (info.name) ivarInfos[info.name] = info;
        }
        free(ivars);
    }
    
    if (!_ivarInfos) _ivarInfos = @{};
    if (!_methodInfos) _methodInfos = @{};
    if (!_propertyInfos) _propertyInfos = @{};
    
    _needUpdate = NO;
}

- (void)setNeedUpdate {
    _needUpdate = YES;
}

- (BOOL)needUpdate {
    return _needUpdate;
}


// 获取cls 对cls处理
+ (instancetype)classInfoWithClass:(Class)cls {
    //判空
    if (!cls) return nil;
    ///在此使用CF库的CFMutableDictionaryRef
    ///单例模式
    static CFMutableDictionaryRef classCache;   //class 缓存容器
    static CFMutableDictionaryRef metaCache;    //meta class 缓存容器
    static dispatch_once_t onceToken;
    /*
     *GCD信号
     */
    static dispatch_semaphore_t lock; //线程安全  线程加锁。
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    //加锁   如果semaphore计数大于等于1.计数－1，返回，程序继续运行。 计数为0则等待
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    //在缓存中取值，分元类和class
    YYClassInfo *info = CFDictionaryGetValue(class_isMetaClass(cls) ? metaCache : classCache, (__bridge const void *)(cls));
    // 是否找到info并且需要进行刷新
    if (info && info->_needUpdate) {
        [info _update];
    }
    // 释放信号量 计数+1
    dispatch_semaphore_signal(lock);
    
    //不存在，就要创建
    if (!info) {
        // info不在缓存容器中
        // 通过initWithClass重新创建一个info
        info = [[YYClassInfo alloc] initWithClass:cls];
        if (info) {
            // 缓存到对应的容器中
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            // 再一次判断是meta还是class
            CFDictionarySetValue(info.isMeta ? metaCache : classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    return info;
}

//通过 string获取class 再对class处理 ，
+ (instancetype)classInfoWithClassName:(NSString *)className {
    Class cls = NSClassFromString(className);
    return [self classInfoWithClass:cls];
}

@end
