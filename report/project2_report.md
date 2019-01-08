# Computer Architecture Project 2

## Members

| Member           | Work                            |
| ---------------- | ------------------------------- |
| B05902003 李哲安 | CPU 優化、Testbench、整體測試   |
| B05902049 簡崇安 | Data Memory、Cache、Report 撰寫 |
| B05902109 柯上優 | Cache Controller                |

## Implementation

![datapath](../image/datapath.png?raw=true)

* 上頁的圖為 Project 1 的大架構，在 Project 2 中我們基本上沿用以上架構，並在 memory 的部分由一個 cache controller 控制 cache 與 memory 的讀寫。
* 信號控制方面，會由 cache controller 接收 read/write 的信號，並由內部的 finite state machine 掌控流程，在適當的 cycle 接收、送出信號。
* 我們共使用 5 個 state 來控制信號：
  * STATE_IDLE：等待接收 read/write 的信號。接收後轉移至 STATE_CHECK。
  * STATE_CHECK：確認 hit/miss，如果發生 miss 根據 dirty bit 轉移至 STATE_WRITE_BACK 或 STATE_ALLOCATE，否則進行讀寫並回到 STATE_IDLE。
  * STATE_WRITE_BACK：寫入 memory，等待 ack 信號並轉移到 STATE_ALLOCATE。
  * STATE_ALLOCATE：讀取 memory，轉移到 STATE_ALLOCATE_FINISHED。
  * STATE_ALLOCATE_FINISHED：設定 valid bit 並將讀取到的資料寫入 cache，並轉移回 STATE_CHECK。

### Changes

* 新增 stall 信號確保 CPU 整體狀態一致。
* 原先的 adder 與 multiplexer 是分別採用不同的 module，而在 Project 2 中我們改採用同樣的 module 使架構更清楚。
* 與範例架構較明顯的不同點是我們將 cache 與 memory 這兩個 module 放在 CPU 中，由 cache contorller 來控制。此外，我們將 cache 的 tag 與 data 由同一個 module 來管理。
* 將 CPU 中的接線全部改用 wire，使得偵錯更為容易。

## Compilation & Execution

```bash
cd code
make
./testbench
```

## Problems and Solutions

- 在調整 Project 1 的接線（將 CPU 內的接線改用 wire）後，出現大量的 x 導致整體流程出錯。
  - 解決方式：確認接線並參考 Project 1 的流程圖後調整成正確的輸入輸出。
- 每次讀寫記憶體的 cycle 停留次數與範例不同。
  - 解決方式：由於規範中沒有規定要完全吻合，且 cache 的架構與原本附的稍有不同，就沒有繼續調整了。
- 在 cache 中無法正確讀寫。
  - 解決方式：將信號用 reg 儲存，讓信號在正確的 cycle 控制 memory 與 cache，使讀寫結果正確。