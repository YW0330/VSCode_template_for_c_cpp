# Visual Studio Code C/C++ 專案模板
跨平台環境中使用 Visual Studio Code 對 c 或 cpp 檔案進行編譯，並提供 Release 與 Debug 模式。

## 預先準備工作
### 安裝 Visual Studio Code
- [官方網站](https://code.visualstudio.com/)

### 安裝編譯和偵錯工具
安裝使用 C/C++ 所需要的工具，如 gcc、g++、gdb。
#### 官方教學
- [Linux](https://code.visualstudio.com/docs/cpp/config-linux)
- [Windows](https://code.visualstudio.com/docs/cpp/config-mingw)
#### 筆者使用方法 (Windows)
- [安裝 Mingw-w64 教學](https://hackmd.io/lP1-gxvySE272znXo7LOhg?view)

## 使用方法
### 語言設定
於 `Makefile` 中的 `LANG` 變數設定成想要撰寫的語言，若預編寫 C 語言，則 `LANG = c`；若預編寫 C++ 語言，則 `LANG = cpp`。預設為 C++。

### 各資料夾簡介：
- `test` 資料夾放置測試主程式，即包含 main 函式 (*.c, *.cpp)
- `src` 資料夾放置自定義函式的原始碼 (*.c, *.cpp)
- `include` 資料夾放置各式標頭檔 (*.h, *.hpp)
- `lib` 資料夾放置各式資料庫 (*.a, *.o, *.lib, *.dll)
- `.vscode` 放置 VSCode 設定檔

### 常用操作命令：
Visual Studio Code 偵錯模式：
在想要偵錯的測試主程式頁面中，行號左側欄設置中斷點。接著點選 VSCode 左側`執行與偵錯`頁籤 -> 點選上方的 `C/C++: g++ 建置及偵錯使用中的檔案`；或是直接按下 `F5` 進行偵錯。

#### Linux 作業系統
- 終端機中編譯檔案並執行
    ```shell
    $ make
    ```
    可以更改 `Makefile` 中的 `FILENAME` 來選擇自行新建的檔案。或是執行
    ```shell
    $ make FILENAME=<desired filename>
    ```
    其他個人化選項，請參考 `Makefile` 中的註解。
#### Windows 作業系統
- 終端機中編譯檔案並執行: 將命令從 `make` 變更為 `mingw32-make`。



