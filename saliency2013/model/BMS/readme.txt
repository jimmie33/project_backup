The code has been tested on Windows system, using Matlab 2012 and OpenCV 2.40+.

To compile the code (only for Windows):

1. Put the extracted files in a **<root_dir>**.
2. Install OpenCV 2.40+.
3. Go to **<root_dir>/mex/** and specify the relevant OpenCV paths at the 
   begining of the **compile.m**. 
4. Run **compile.m** in Matlab.
5. Go to **<root_dir>** and run **demo.m** in Matlab.

It should be easy to compile the mex file on other platforms, too.

If you use an old version of Matlab, and encounter some compiling problems related to
**char16_t**, please uncomment the following lines in **<root_dir>/mex/MxArray.hpp**:

//#ifdef _CHAR16T
//#define CHAR16_T
//#endif