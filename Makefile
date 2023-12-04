# 語言設定 [C 語言: c, C++: cpp]
LANG = cpp
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

# 編譯器設定
ifeq ($(LANG), c)
CC = gcc
else ifeq ($(LANG), cpp)
CC = g++
endif
CFLAG = -Wall -fexec-charset=BIG5
INCLUDEPATH = $(foreach include, $(INCLUDEDIR), -I$(include))
LIBPATH = $(foreach lib, $(LIBDIR), -L$(lib))
LIBS = $(foreach libname, $(LIBSNAME), -l$(libname))

SRCS = $(wildcard $(SRCDIR)/*.$(LANG))
SRCOBJS = $(patsubst %.$(LANG), %.o, $(SRCS))
OBJS = $(SRCOBJS)

TESTSRCS = $(wildcard $(TESTDIR)/*.$(LANG))
TESTOBJS = $(patsubst %.$(LANG), %.o, $(TESTSRCS))
TESTEXES = $(patsubst %.$(LANG), %.exe, $(TESTSRCS))

TARGETSRC = $(TESTDIR)/$(FILENAME).$(LANG)
TARGETOBJ = $(patsubst %.$(LANG), %.o, $(TARGETSRC))
TARGETEXE = $(patsubst %.$(LANG), %.exe, $(TARGETSRC))

# 最佳化設定
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

%.o: %.$(LANG)
	@$(CC) $(CFLAG) -c $< -o $@ $(INCLUDEPATH)

.SECONDARY: $(OBJS)

run:
	@echo "===== Program Start ====="
ifeq ($(OS), Linux)
	@sudo LD_LIBRARY_PATH=$(LIBDIR) $(TARGETEXE)
else ifeq ($(OS), Windows_NT)
	@$(TARGETEXE)
endif
	@echo "===== Program End ====="

.PHONY: clean
clean:
ifeq ($(OS), Linux)
	@rm -f $(TESTDIR)/*.exe
	@rm -f $(SRCDIR)/*.o $(TESTDIR)/*.o
else ifeq ($(OS), Windows_NT)
	@del /f $(TESTDIR)\*.exe
	@del /f $(SRCDIR)\*.o $(TESTDIR)\*.o
endif