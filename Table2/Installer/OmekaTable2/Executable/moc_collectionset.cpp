/****************************************************************************
** Meta object code from reading C++ file 'collectionset.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.9.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../OmekaTable2/collectionset.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'collectionset.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.9.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_CollectionSet_t {
    QByteArrayData data[12];
    char stringdata0[182];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_CollectionSet_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_CollectionSet_t qt_meta_stringdata_CollectionSet = {
    {
QT_MOC_LITERAL(0, 0, 13), // "CollectionSet"
QT_MOC_LITERAL(1, 14, 19), // "getCollectionOption"
QT_MOC_LITERAL(2, 34, 0), // ""
QT_MOC_LITERAL(3, 35, 5), // "index"
QT_MOC_LITERAL(4, 41, 12), // "getNextImage"
QT_MOC_LITERAL(5, 54, 21), // "getNextImageBaseWidth"
QT_MOC_LITERAL(6, 76, 22), // "getNextImageBaseHeight"
QT_MOC_LITERAL(7, 99, 17), // "getNextImageWidth"
QT_MOC_LITERAL(8, 117, 11), // "base_height"
QT_MOC_LITERAL(9, 129, 18), // "getNextImageHeight"
QT_MOC_LITERAL(10, 148, 10), // "base_width"
QT_MOC_LITERAL(11, 159, 22) // "getNextImageCollection"

    },
    "CollectionSet\0getCollectionOption\0\0"
    "index\0getNextImage\0getNextImageBaseWidth\0"
    "getNextImageBaseHeight\0getNextImageWidth\0"
    "base_height\0getNextImageHeight\0"
    "base_width\0getNextImageCollection"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_CollectionSet[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,   49,    2, 0x02 /* Public */,
       4,    0,   52,    2, 0x02 /* Public */,
       5,    0,   53,    2, 0x02 /* Public */,
       6,    0,   54,    2, 0x02 /* Public */,
       7,    1,   55,    2, 0x02 /* Public */,
       9,    1,   58,    2, 0x02 /* Public */,
      11,    0,   61,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::QString, QMetaType::Int,    3,
    QMetaType::QString,
    QMetaType::Float,
    QMetaType::Float,
    QMetaType::Float, QMetaType::Int,    8,
    QMetaType::Float, QMetaType::Int,   10,
    QMetaType::QString,

       0        // eod
};

void CollectionSet::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        CollectionSet *_t = static_cast<CollectionSet *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: { QString _r = _t->getCollectionOption((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 1: { QString _r = _t->getNextImage();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 2: { float _r = _t->getNextImageBaseWidth();
            if (_a[0]) *reinterpret_cast< float*>(_a[0]) = std::move(_r); }  break;
        case 3: { float _r = _t->getNextImageBaseHeight();
            if (_a[0]) *reinterpret_cast< float*>(_a[0]) = std::move(_r); }  break;
        case 4: { float _r = _t->getNextImageWidth((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< float*>(_a[0]) = std::move(_r); }  break;
        case 5: { float _r = _t->getNextImageHeight((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< float*>(_a[0]) = std::move(_r); }  break;
        case 6: { QString _r = _t->getNextImageCollection();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
}

const QMetaObject CollectionSet::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_CollectionSet.data,
      qt_meta_data_CollectionSet,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *CollectionSet::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *CollectionSet::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_CollectionSet.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int CollectionSet::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 7)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 7;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
