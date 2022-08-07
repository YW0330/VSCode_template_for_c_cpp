# 編譯執行的檔案名(要包含 main 函式)
FILENAME ?= main
# 引用到的 libary 名稱
LIBSNAME = 
# include 的路徑
INCLUDEDIR = ./include
# libary 的路徑
LIBDIR = ./lib

# ----- 以下沒有特殊需求不需要進行修改 -----
# 存放測試主程式的資料夾名稱(要包含 main 函式)
TESTDIR = test
# 自定義的函式資料夾名稱
SRCDIR = src
# release/debug 模式
MODE ?= release
# 作業系統
PLATFORM ?= linux

# 編譯器設定
CC = g++
CFLAG = -Wall -std=c++11 -fexec-charset=UTF8 
INCLUDEPATH = $(foreach include, $(INCLUDEDIR), -I$(include))
LIBPATH = $(foreach lib, $(LIBDIR), -L$(lib))
LIBS = $(foreach libname, $(LIBSNAME), -l$(libname))

SRC = $(wildcard $(SRCDIR)/*.cpp)
SRCOBJ = $(patsubst %.cpp, %.o, $(SRC))

TESTSRC = $(wildcard $(TESTDIR)/*.cpp)
TESTEXE = $(patsubst %.cpp, %.exe, $(TESTSRC))

TARGETSRC = $(TESTDIR)/$(FILENAME).cpp
TARGETEXE = $(patsubst %.cpp, %.exe, $(TARGETSRC))

ifeq ($(MODE), debug)
CFLAG += -g
all: clean target 
else
CFLAG += -Os
all: clean target run 
endif

compile: $(TESTEXE)
target: $(TARGETEXE) 

%.exe: %.o $(SRCOBJ)
	@$(CC) $(CFLAG) $^ -o $@ $(INCLUDEPATH) $(LIBS) $(LIBPATH)

%.o: %.cpp
	@$(CC) $(CFLAG) -c $< -o $@ $(INCLUDEPATH)

run:
	@echo "\n=====Program Start====="
ifeq ($(PLATFORM), linux)
	@sudo LD_LIBRARY_PATH=$(LIBDIR) $(TARGETEXE)
else ifeq ($(PLATFORM), windows)
	@LD_LIBRARY_PATH=$(LIBDIR) $(TARGETEXE)
endif
	@echo "\n=====Program End====="

.PHONY: clean
clean:
ifeq ($(PLATFORM), linux)
	@rm -f $(TESTDIR)/*.exe
	@rm -f $(SRCDIR)/*.o $(TESTDIR)/*.o
else ifeq ($(PLATFORM), windows)
	@del $(TESTDIR)\*.exe
	@del $(SRCDIR)\*.o $(TESTDIR)\*.o
endif
	