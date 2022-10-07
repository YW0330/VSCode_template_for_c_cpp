# 編譯執行的檔案名(要包含 main 函式)
FILENAME ?= main
# 作業系統 linux/windows
PLATFORM ?= windows
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


# 編譯器設定
CC = g++
CFLAG = -Wall -fexec-charset=BIG5
INCLUDEPATH = $(foreach include, $(INCLUDEDIR), -I$(include))
LIBPATH = $(foreach lib, $(LIBDIR), -L$(lib))
LIBS = $(foreach libname, $(LIBSNAME), -l$(libname))

SRCS = $(wildcard $(SRCDIR)/*.cpp)
SRCOBJS = $(patsubst %.cpp, %.o, $(SRCS))
OBJS = $(SRCOBJS)

TESTSRCS = $(wildcard $(TESTDIR)/*.cpp)
TESTOBJS = $(patsubst %.cpp, %.o, $(TESTSRCS))
TESTEXES = $(patsubst %.cpp, %.exe, $(TESTSRCS))

TARGETSRC = $(TESTDIR)/$(FILENAME).cpp
TARGETOBJ = $(patsubst %.cpp, %.o, $(TARGETSRC))
TARGETEXE = $(patsubst %.cpp, %.exe, $(TARGETSRC))

ifeq ($(MODE), debug)
CFLAG += -g
default: clean target 
else
CFLAG += -Os
default: clean target run 
all: clean compile
endif

compile: $(TESTEXES)
OBJS += $(TESTOBJS)
	
target: $(TARGETEXE) 
OBJS += $(TARGETOBJ)
	
%.exe: %.o $(SRCOBJS)
	@$(CC) $(CFLAG) $^ -o $@ $(INCLUDEPATH) $(LIBS) $(LIBPATH)

%.o: %.cpp
	@$(CC) $(CFLAG) -c $< -o $@ $(INCLUDEPATH)

.SECONDARY: $(OBJS)

run:
	@echo "===== Program Start ====="
ifeq ($(PLATFORM), linux)
	@sudo LD_LIBRARY_PATH=$(LIBDIR) $(TARGETEXE)
else ifeq ($(PLATFORM), windows)
	@$(TARGETEXE)
endif
	@echo "===== Program End ====="

.PHONY: clean
clean:
ifeq ($(PLATFORM), linux)
	@rm -f $(TESTDIR)/*.exe
	@rm -f $(SRCDIR)/*.o $(TESTDIR)/*.o
else ifeq ($(PLATFORM), windows)
	@del $(TESTDIR)\*.exe
	@del $(SRCDIR)\*.o $(TESTDIR)\*.o
endif