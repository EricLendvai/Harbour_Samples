// File came from https://github.com/FiveTechSoft/harbour_python  for original solution for calling Python code in Harbour

#include <hbapi.h>
#include <Python.h>

HB_FUNC( PY_GETERROR )
{
   PyObject * type, * value, * traceback;
   PyErr_Fetch( &type, &value, &traceback );

   if( value ) 
   {
      void * str_exc = PyObject_Str(value);
      const char * c_str_exc = PyUnicode_AsUTF8(str_exc);
      hb_retc( c_str_exc );
    }
}

HB_FUNC( PY_INITIALIZE )
{
   Py_Initialize();
}

HB_FUNC( PYIMPORT_IMPORTMODULE )
{
   hb_retptr( PyImport_ImportModule( hb_parc( 1 ) ) );
}

HB_FUNC( PYOBJECT_GETATTRSTRING )
{
   hb_retptr( PyObject_GetAttrString( hb_parptr( 1 ), hb_parc( 2 ) ) );
}

HB_FUNC( PYFLOAT_FROMDOUBLE )
{
   hb_retptr( PyFloat_FromDouble( hb_parnd( 1 ) ) );
}

HB_FUNC( PYOBJECT_CALLFUNCTIONOBJARGS )
{
   switch( hb_pcount() )
   {
      case 1:
         hb_retptr( PyObject_CallFunctionObjArgs( hb_parptr( 1 ), NULL ) );
         break;

      case 2:
         hb_retptr( PyObject_CallFunctionObjArgs( hb_parptr( 1 ), hb_parptr( 2 ), NULL ) );
         break;

      case 3:      
         hb_retptr( PyObject_CallFunctionObjArgs( hb_parptr( 1 ), hb_parptr( 2 ), hb_parptr( 3 ), NULL ) );
         break;

      case 4:      
         hb_retptr( PyObject_CallFunctionObjArgs( hb_parptr( 1 ), hb_parptr( 2 ), hb_parptr( 3 ), hb_parptr( 4 ), NULL ) );
         break;

      default:
         // generate error reporting increase this switch
         break;   
   }
}

HB_FUNC( PYOBJECT_CALLMETHOD )
{
   switch( hb_pcount() )
   {
      case 2:
         hb_retptr( PyObject_CallMethod( hb_parptr( 1 ), hb_parc( 2 ), NULL ) );
         break;

      case 3:      
         hb_retptr( PyObject_CallMethod( hb_parptr( 1 ), hb_parc( 2 ), hb_parptr( 3 ), NULL ) );
         break;

      case 4:      
         hb_retptr( PyObject_CallMethod( hb_parptr( 1 ), hb_parc( 2 ), hb_parc( 3 ), hb_parptr( 4 ), NULL ) );
         break;

      default:
         // generate error reporting increase this switch
         break;   
   }
}

HB_FUNC( PYFLOAT_ASDOUBLE )
{
   hb_retnd( PyFloat_AsDouble( hb_parptr( 1 ) ) );   
}

HB_FUNC( PY_FINALIZE )
{
   Py_Finalize();
}

HB_FUNC( PY_DECREF )
{
   Py_DecRef( hb_parptr( 1 ) );
}

HB_FUNC( PYLIST_NEW )
{
   hb_retptr( PyList_New( hb_parni( 1 ) ) );
}

HB_FUNC( PYLIST_SETITEM )
{
   PyList_SetItem( hb_parptr( 1 ), hb_parni( 2 ), hb_parptr( 3 ) );
}

HB_FUNC( PYERR_PRINT )
{
   PyErr_Print();
}

HB_FUNC( PYERR_OCCURRED )
{
   hb_retl( PyErr_Occurred() == NULL );
}

HB_FUNC( PYUNICODE_FROMSTRING )
{
   hb_retptr( PyUnicode_FromString( hb_parc( 1 ) ) );
}