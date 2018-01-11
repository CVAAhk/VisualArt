/****************************************************************************
** Meta object code from reading C++ file 'collections.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.9.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../OmekaTable2/collections.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'collections.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.9.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Collections_t {
    QByteArrayData data[19];
    char stringdata0[277];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Collections_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Collections_t qt_meta_stringdata_Collections = {
    {
QT_MOC_LITERAL(0, 0, 11), // "Collections"
QT_MOC_LITERAL(1, 12, 19), // "getCollectionOption"
QT_MOC_LITERAL(2, 32, 0), // ""
QT_MOC_LITERAL(3, 33, 5), // "index"
QT_MOC_LITERAL(4, 39, 12), // "getNextImage"
QT_MOC_LITERAL(5, 52, 3), // "set"
QT_MOC_LITERAL(6, 56, 21), // "getNextImageBaseWidth"
QT_MOC_LITERAL(7, 78, 22), // "getNextImageBaseHeight"
QT_MOC_LITERAL(8, 101, 17), // "getNextImageWidth"
QT_MOC_LITERAL(9, 119, 11), // "base_height"
QT_MOC_LITERAL(10, 131, 18), // "getNextImageHeight"
QT_MOC_LITERAL(11, 150, 10), // "base_width"
QT_MOC_LITERAL(12, 161, 22), // "getNextImageCollection"
QT_MOC_LITERAL(13, 184, 13), // "getImageTitle"
QT_MOC_LITERAL(14, 198, 6), // "source"
QT_MOC_LITERAL(15, 205, 12), // "getImageDate"
QT_MOC_LITERAL(16, 218, 14), // "getImageArtist"
QT_MOC_LITERAL(17, 233, 19), // "getImageDescription"
QT_MOC_LITERAL(18, 253, 23) // "collectionsOptionsCount"

    },
    "Collections\0getCollectionOption\0\0index\0"
    "getNextImage\0set\0getNextImageBaseWidth\0"
    "getNextImageBaseHeight\0getNextImageWidth\0"
    "base_height\0getNextImageHeight\0"
    "base_width\0getNextImageCollection\0"
    "getImageTitle\0source\0getImageDate\0"
    "getImageArtist\0getImageDescription\0"
    "collectionsOptionsCount"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Collections[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      11,   14, // methods
       1,  106, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,   69,    2, 0x02 /* Public */,
       4,    1,   72,    2, 0x02 /* Public */,
       6,    1,   75,    2, 0x02 /* Public */,
       7,    1,   78,    2, 0x02 /* Public */,
       8,    2,   81,    2, 0x02 /* Public */,
      10,    2,   86,    2, 0x02 /* Public */,
      12,    1,   91,    2, 0x02 /* Public */,
      13,    1,   94,    2, 0x02 /* Public */,
      15,    1,   97,    2, 0x02 /* Public */,
      16,    1,  100,    2, 0x02 /* Public */,
      17,    1,  103,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::QString, QMetaType::Int,    3,
    QMetaType::QString, QMetaType::Int,    5,
    QMetaType::Float, QMetaType::Int,    5,
    QMetaType::Float, QMetaType::Int,    5,
    QMetaType::Float, QMetaType::Int, QMetaType::Int,    5,    9,
    QMetaType::Float, QMetaType::Int, QMetaType::Int,    5,   11,
    QMetaType::QString, QMetaType::Int,    5,
    QMetaType::QString, QMetaType::QString,   14,
    QMetaType::QString, QMetaType::QString,   14,
    QMetaType::QString, QMetaType::QString,   14,
    QMetaType::QString, QMetaType::QString,   14,

 // properties: name, type, flags
      18, QMetaType::Int, 0x00095401,

       0        // eod
};

void Collections::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Collections *_t = static_cast<Collections *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: { QString _r = _t->getCollectionOption((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 1: { QString _r = _t->getNextImage((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 2: { float _r = _t->getNextImageBaseWidth((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< float*>(_a[0]) = std::move(_r); }  break;
        case 3: { float _r = _t->getNextImageBaseHeight((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< float*>(_a[0]) = std::move(_r); }  break;
        case 4: { float _r = _t->getNextImageWidth((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< float*>(_a[0]) = std::move(_r); }  break;
        case 5: { float _r = _t->getNextImageHeight((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< float*>(_a[0]) = std::move(_r); }  break;
        case 6: { QString _r = _t->getNextImageCollection((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 7: { QString _r = _t->getImageTitle((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 8: { QString _r = _t->getImageDate((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 9: { QString _r = _t->getImageArtist((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 10: { QString _r = _t->getImageDescription((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        Collections *_t = static_cast<Collections *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< int*>(_v) = _t->getCollectionsCount(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

const QMetaObject Collections::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_Collections.data,
      qt_meta_data_Collections,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *Collections::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Collections::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Collections.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Collections::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 11)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 11)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 11;
    }
#ifndef QT_NO_PROPERTIES
   else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 1;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
