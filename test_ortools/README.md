# google-or-practise 

### Download as binary
In order to run the code first you need to install google-or-tools in your local machine https://developers.google.com/optimization/install/cpp/linux.  
I'm using google-or-tools v9.3.10502.  
Once you have the downloaded the tar file from the official website, extract it and change directory to the root folder.

### Download from source (Recommended)
Clone this repository https://github.com/google/or-tools/tree/main or https://github.com/google/or-tools/tree/stable
```
git clone git@github.com:google/or-tools.git
```

### dependencies
```
Cmake > 3.20
C++17 at least
```
### How to build
https://github.com/google/or-tools/blob/main/cmake/README.md#cmake-options
In the root directory
```
cmake -S. -Bbuild -DBUILD_DEPS:BOOL=ON
cmake --build build
```

Save your program as a .cc file inside the root folder.  


### To run you code :
```
make run SOURCE=/relative/pathtoroot/file_name.cc
```

### Sample output images can be found here:
https://drive.google.com/drive/folders/1ohbTNOe78cWOZCREXC6Bj-xpYAJ6K0Ax?usp=sharing
