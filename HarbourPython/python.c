// File came from https://github.com/FiveTechSoft/harbour_python  for original solution for calling Python code in Harbour

// https://docs.python.org/3/c-api/unicode.html

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
   //https://docs.python.org/3/c-api/object.html
   //PyObject *PyObject_GetAttrString(PyObject *o, const char *attr_name)
   //  Return value: New reference. Part of the Stable ABI.
   //  Retrieve an attribute named attr_name from object o. Returns the attribute value on success, or NULL on failure. This is the equivalent of the Python expression o.attr_name.

}

HB_FUNC( PYFLOAT_FROMDOUBLE )
{
   hb_retptr( PyFloat_FromDouble( hb_parnd( 1 ) ) );

   // https://docs.python.org/3/c-api/float.html
   // PyObject *PyFloat_FromDouble(double v)
   //  Return value: New reference. Part of the Stable ABI.
   //  Create a PyFloatObject object from v, or NULL on failure.

}

HB_FUNC( PYOBJECT_CALLFUNCTIONOBJARGS )
{
   //https://docs.python.org/3/c-api/call.html#c.PyObject_CallFunctionObjArgs
   // Call a callable Python object callable, with a variable number of PyObject* arguments. The arguments are provided as a variable number of parameters followed by NULL.
   // Return the result of the call on success, or raise an exception and return NULL on failure.
   // This is the equivalent of the Python expression: callable(arg1, arg2, ...).

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
   //https://docs.python.org/3/c-api/call.html#c.PyObject_CallFunctionObjArgs

   // PyObject *PyObject_CallMethod(PyObject *obj, const char *name, const char *format, ...)
   //    Return value: New reference. Part of the Stable ABI.
   //    Call the method named name of object obj with a variable number of C arguments. The C arguments are described by a Py_BuildValue() format string that should produce a tuple.
   //    The format can be NULL, indicating that no arguments are provided.
   //    Return the result of the call on success, or raise an exception and return NULL on failure.
   //    This is the equivalent of the Python expression: obj.name(arg1, arg2, ...).
   //    Note that if you only pass PyObject* args, PyObject_CallMethodObjArgs() is a faster alternative.
   //    Changed in version 3.4: The types of name and format were changed from char *.

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

   //https://docs.python.org/3/c-api/float.html
   // double PyFloat_AsDouble(PyObject *pyfloat)
   //    Part of the Stable ABI.
   //    Return a C double representation of the contents of pyfloat. If pyfloat is not a Python floating point object but has a __float__() method, this method will first be called to convert pyfloat into a float. If __float__() is not defined then it falls back to __index__(). This method returns -1.0 upon failure, so one should call PyErr_Occurred() to check for errors.
   //    Changed in version 3.8: Use __index__() if available.

   hb_retnd( PyFloat_AsDouble( hb_parptr( 1 ) ) );   
}

HB_FUNC( PYSTRING_ASSTRING )
{

   //https://docs.python.org/3/c-api/unicode.html
   // PyObject *PyUnicode_AsUTF8String(PyObject *unicode)
   //    Return value: New reference. Part of the Stable ABI.
   //    Encode a Unicode object using UTF-8 and return the result as Python bytes object. Error handling is “strict”. Return NULL if an exception was raised by the codec.

   void * str_exc = PyObject_Str(hb_parptr( 1 ));
   const char * c_str_exc = PyUnicode_AsUTF8(str_exc);
   hb_retc( c_str_exc );
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