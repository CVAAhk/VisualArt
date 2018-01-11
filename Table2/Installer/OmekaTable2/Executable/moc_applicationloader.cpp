/****************************************************************************
** Meta object code from reading C++ file 'applicationloader.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.9.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../OmekaTable2/applicationloader.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'applicationloader.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.9.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_ApplicationLoader_t {
    QByteArrayData data[8];
    char stringdata0[88];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_ApplicationLoader_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_ApplicationLoader_t qt_meta_stringdata_ApplicationLoader = {
    {
QT_MOC_LITERAL(0, 0, 17), // "ApplicationLoader"
QT_MOC_LITERAL(1, 18, 13), // "objectCreated"
QT_MOC_LITERAL(2, 32, 0), // ""
QT_MOC_LITERAL(3, 33, 6), // "object"
QT_MOC_LITERAL(4, 40, 3), // "url"
QT_MOC_LITERAL(5, 44, 17), // "viewStatusChanged"
QT_MOC_LITERAL(6, 62, 18), // "QQuickView::Status"
QT_MOC_LITERAL(7, 81, 6) // "status"

    },
    "ApplicationLoader\0objectCreated\0\0"
    "object\0url\0viewStatusChanged\0"
    "QQuickView::Status\0status"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ApplicationLoader[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    2,   24,    2, 0x0a /* Public */,
       5,    1,   29,    2, 0x0a /* Public */,

 // slots: parameters
    QMetaType::Void, QMetaType::QObjectStar, QMetaType::QUrl,    3,    4,
    QMetaType::Void, 0x80000000 | 6,    7,

       0        // eod
};

void ApplicationLoader::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        ApplicationLoader *_t = static_cast<ApplicationLoader *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->objectCreated((*reinterpret_cast< QObject*(*)>(_a[1])),(*reinterpret_cast< const QUrl(*)>(_a[2]))); break;
        case 1: _t->viewStatusChanged((*reinterpret_cast< QQuickView::Status(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObject ApplicationLoader::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_ApplicationLoader.data,
      qt_meta_data_ApplicationLoader,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *ApplicationLoader::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ApplicationLoader::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_ApplicationLoader.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int ApplicationLoader::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 2)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 2;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
