# TaiLocal 最台繁

> **Taiwan + Localization** — 简体中文 → 台湾繁體中文 的专业批量转换工具

**English keywords:** Taiwan localization · Simplified to Traditional Chinese converter · zh-CN to zh-TW · OpenCC alternative · Taiwanese Mandarin terminology · Excel batch translation · GUI desktop tool · 免安裝 · 台灣用語轉換 · 繁體中文本地化

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 這是什麼 / What is this

把簡體中文產品文案批量轉換成「台灣人一眼覺得自然」的繁體中文。

**簡轉繁不是字符轉換，是在地化。** 通用工具只會把「内存」轉成「內存」，台灣用戶一看就知道是對岸寫的。TaiLocal 轉出來的是：

| 簡體原文 | 普通工具輸出 | TaiLocal 輸出 |
|---|---|---|
| 内存不足 | 內存不足 | **記憶體**不足 |
| 卸载驱动 | 卸載驅動 | **解除安裝**驅動 |
| 网络设置 | 網絡設置 | **網路設定** |
| 项目参数 | 項目參數 | **專案參數** |

## ✨ 特性 / Features

- **🖥️ 圖形界面**：打開軟體 → 選 Excel → 翻譯完成。檔案叫什麼名字、在哪個碟都行，輸出自動存在原檔案旁邊
- **📚 兩級術語庫**：`terms.csv` 公共術語（千條級）+ `terms_private.csv` 個人術語（自動疊加，長詞優先）
- **🔒 英文語義鎖定**：根據英文原文鎖定譯法 —— `unmount→卸載`、`uninstall→解除安裝`、`remove→移除`，杜絕 OpenCC 誤翻
- **🛡️ HTML 保護**：`<b>软件设置</b>` 轉換後標籤完好無損
- **🔧 post_fix 二次修正**：OpenCC 轉完再過一遍人工校對規則（`滑鼠`、`帆船`、` connection埠` 這類坑全部兜住）
- **📋 全程 Log**：每條輸出記錄原文/結果/命中術語/未命中術語，方便審計與補詞

## ⚡ 三分鐘上手 / 3-Minute Start（最簡指南）

**第 1 步：下載**

- 🟢 **我不會裝 Python** → 到右側 [Releases](https://github.com/lyviama/TaiLocal/releases) 下載 `TaiLocal.exe`（Windows 免安裝，雙擊即用）
- 🔵 **我會用 Python** → 點綠色 `Code` 按鈕 → `Download ZIP` → 解壓

**第 2 步：準備一個 Excel**

- 你的文案表（`.xlsx`），有中文那列就行，表頭叫什麼都隨意

**第 3 步：轉換**

```
下載檔案 → 雙擊 TaiLocal.exe → 選擇你的 Excel → 完成
                                              ↓
                            原文件旁邊多出一個「xxx_tw.xlsx」
                            裡面新增一列 _zh-TW 就是台灣繁體
```

**遇到轉錯的詞？** 軟體裡用「🔍 術語查詢」搜這個詞 → 照提示加進 `post_fix.csv` → 重新轉換。完畢。

> 技術細節（命令行 / 自行打包 / 術語庫進階維護）往下看 ↓

## 🚀 快速開始 / Quick Start

### 方式一：直接運行（需 Python 3.8+）

```bash
pip install -r requirements.txt
python tailocal.py        # 打開圖形界面
```

### 方式二：命令行

```bash
python tailocal.py 你的文件.xlsx
```

### 方式三：打包成免安裝軟體（推薦給非技術用戶）

```bash
# Windows：雙擊 build_exe.bat，或命令行：
pip install pyinstaller
pyinstaller --onefile --noconsole --name TaiLocal tailocal.py
# → dist/TaiLocal.exe 雙擊即用

# macOS：
pyinstaller --onefile --windowed --name TaiLocal tailocal.py
# → dist/TaiLocal
```

## 📖 Excel 格式 / Input Format

**表頭不用改、格式隨意** —— 任何 `.xlsx` 直接選進來就能翻。工具會自動猜列：

**① 中文列（必須有，但表頭名不拘）**

按順序自動識別：表頭叫「中文」「zh-cn」「zh-Hans」「simplified」「sc」「cn」任一種 → 用它；都沒有 → **直接把第 1 列當中文列**。

**② 英文列（可選，強烈建議）**

表頭含「en-US」「en」「english」字樣的列會被自動當成英文原文列，用於語義鎖定。

**為什麼建議加英文列？** 同一個「卸载」，英文原文不同，台繁譯法完全不同：

| 中文 | 英文原文 | TaiLocal 輸出 |
|---|---|---|
| 卸载 | Uninstall | **解除安裝** |
| 卸载 | Unmount | **卸載** |
| 卸载 | Remove | **移除** |

沒有英文列也能翻（術語庫+OpenCC 照常工作），只是遇到這種一詞多義的情況無法自動選對譯法。

**舉例** —— 以下三種表格都能直接翻：

```
✓ 表頭「中文」的產品文案表          → 自動識別中文列
✓ 表頭「zh-CN」+「en-US」的本地化表 → 中文列+語義鎖定全開
✓ 沒有表頭、第一列就是簡體的表     → 第1列兜底
```

輸出：原檔案旁生成 `原檔名_tw_日期時間.xlsx`，中文列對應新增一列 `_zh-TW`（不改動你原本的任何列）。

## 📚 更新術語庫 / Update the terminology database

### 方法 A：直接編輯 `terms.csv`

用任何表格軟體打開，兩列格式（UTF-8）：

```
source,target
内存,記憶體
软件,軟體
```

加一行就生效，重啟軟體即可。

### 方法 B：從 Excel 術語總表重建

維護一份 `術語表.xlsx`（A列=簡體，B列=台繁），然後：

```bash
python build_terms.py
```

自動去重、去空行，重新生成 `terms.csv`。

### 個人術語（不影響別人）

建一個 `terms_private.csv`（同樣格式），會自動疊加到公共術語之上。此檔案已被 `.gitignore` 排除，**不會被提交到倉庫** —— 公司/產品专属術語放這裡。

## 🛠️ 二次修正 / post_fix 維護指南

`post_fix.csv` 是轉換流水線的最後一道保險：OpenCC 和術語表都轉完之後，再做一次精確替換。

### 什麼時候需要動它？

- 某個詞轉出來的結果**總是不對**，且術語表加了也覆蓋不掉（被 OpenCC 二次轉換）
- 需要**整批修正**某個固定搭配（如「基礎頻率→時脈」）

### 怎麼加一條規則？

用任意表格軟體打開 `post_fix.csv`，格式只有兩列：

| source | target |
|---|---|
| 基礎頻率 | 時脈 |
| 不透過 | 不通過 |

- `source`：轉換後**錯誤的**繁體詞（注意：是繁體，因為 post_fix 在整條流水線最後執行）
- `target`：你想要的正確寫法
- 儲存後重啟軟體即生效，**不需要重新編譯**

### 排查順序建議

1. 先在軟體的「🔍 術語查詢」裡搜這個詞，看管線實際轉成了什麼
2. 如果是簡→繁就錯了 → 加進 `terms.csv`（或個人 `terms_private.csv`）
3. 如果是繁體詞被二次轉壞 → 加進 `post_fix.csv`

## 🔍 術語查詢與自定義兜底 / Term Lookup & Custom Fallback

GUI 內建術語查詢：輸入任意詞，立刻看到——

- 📚 **術語表**是否收錄、轉換結果
- 🛠️ **post_fix** 是否命中、修正結果
- ❓ 都沒收錄時，顯示管線實際輸出，並提示你把該詞加進 `post_fix.csv` 或 `terms_private.csv` 作為**人工修正兜底**

`terms_private.csv`（與 `terms.csv` 同目錄、同格式）是你的個人術語層，自動疊加、優先於公共術語表，且不會被 git 提交——適合存放專案專屬、公司內部的用詞。

## 🏗️ 轉換流水線 / Pipeline

```
原文 → 引號正規化「」
     → 英文語義鎖定（uninstall/unmount/remove/argument/project…）
     → 術語表替換（長詞優先，佔位符保護）
     → OpenCC s2twp
     → post_fix.csv 二次修正
     → 還原 HTML 標籤與佔位符
     → 輸出 *_tw_*.xlsx + 審計 log
```


## 🛡️ 防呆设计 / Safety Guards

- **檔案佔用檢測**：翻譯前自動檢查檔案是否正被 Excel/WPS 鎖定——若被鎖定，軟體不會崩潰，而是友善提示「請先關閉該表格後重試」
- **輸出權限檢測**：自動確認輸出資料夾可寫，避免翻譯完成後才發現存不了
- **輸出衝突提示**：若輸出檔案正被打開，同樣給出明確指引

> Built for translators, not programmers — every failure mode tells you exactly what to do next.

## 🆚 為什麼不用 OpenCC 就好？ / Why not just use OpenCC?

OpenCC 是優秀的字符級轉換工具，但**字符轉換 ≠ 在地化**。「内存」「软件」「视频」這類詞，OpenCC 只能給出「內存」「軟體」「視頻」（港式）或直轉結果。TaiLocal 在 OpenCC 之上疊加了：

1. **千條級台灣用語術語庫**（科技/NAS/消費電子優化）——「視頻」→「影片」、「網絡」→「網路」
2. **英文語義鎖定**——同一個「卸载」，unmount→卸載、uninstall→解除安裝、remove→移除
3. **post_fix 人工校對層**——兜住 OpenCC 的已知誤翻

簡單說：OpenCC 管「字對不對」，TaiLocal 管「台灣人讀起來對不對」。

## 📄 License

MIT · 歡迎 Star / Fork / PR
