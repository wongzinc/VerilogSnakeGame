# XADC 額外控制模組


> The Dual Analog/Digital Pmod on the Basys 3 differs from the rest in the routing of its traces. The eight data signals are grouped into four pairs, with the pairs routed closely coupled for better analog noise immunity.

>The XADC core within the Artix-7 is a dual channel 12-bit analog-to-digital converter capable of operating at 1 MSPS. Either channel can be driven by any of the auxiliary analog input pairs connected to the JXADC header. The XADC core is controlled and accessed from a user design via the Dynamic Reconfiguration Port (DRP). The DRP also provides access to voltage monitors that are present on each of the FPGA's power rails, and a temperature sensor that is internal to the FPGA.

> [!NOTE]
> 解釋： Artix-7 系列只有4個可用的成對JXADC 引脚. 每一個傳輸資料速度在1MSPS。在選擇IP CATALOG 那裏需選擇DRP 來控制XADC的核心。這個四個成對的原因是VAUXP 和 VAUXN。主要的作用是用於測量兩個引脚之間的電壓差。每個VAUXP 通道都有一個與之相應的VAUXN 通道與之配對。XADC會自動計算VAUXP和VAUXN之間的電壓差,得到實際的輸入電壓。例如,如果你想測量一個-0.5V到+0.5V的信號,你可以將信號的正極連接到VAUXP[6],將信號的負極連接到VAUXN[6],然後將daddr_in設置為0x16。XADC會輸出一個與輸入電壓差成比例的數字量結果。需要注意的是,XADC的輸入範圍是有限的,通常為0到1.8V。如果輸入電壓超出了這個範圍,可能會導致測量結果不準確,甚至可能損壞XADC。因此,在連接輸入信號時,通常需要使用電阻分壓或者運算放大器等電路,將輸入信號的電壓調整到XADC的輸入範圍內。在這個專案中,我們只關心外部的模擬輸入,因此只使用了VAUXP和VAUXN。我們並不需要測量芯片的內部參數,因此將vp_in和vn_in設置為0,表示不使用這兩個通道。當你使用不同的VAUX通道時,會得到不同的電壓值,這是因為每個VAUX通道都連接到FPGA的不同引腳,這些引腳可能連接到電路板上的不同元件或者電路節點。

![Screenshot of unipolar and bipolar mode with circuits diagram](/img/polar_mode.png)

> [!NOTE]
> 另外, XADC 可以測量(0 ~ 1v)單極和(-0.5V ~ 0.5V)雙極。


![Screenshot of xadc pair pins](/img/xadc_pair_pins.png)

> [!NOTE]
> J3和K3配對，L3 和M3配對，以此類推。



更多資訊,請參考：
[1]: https://github.com/Digilent/Basys-3-XADC/blob/master/README.md
[2]: https://www.physics.umd.edu/hep/drew/495/xadc.html

# ARDUINO/ESP-32模組額外控制

**透過這次的專題，我學到了**
<details>
<summary>電路連接</summary>
透過助教的幫助，成功分壓了3.3v 至1v。原來其實可以不用想的那麽複雜（用分壓的方式）。只需要用串聯的方式3.3/（10kohm+10kohm+ 可變（10kohm））=0.11*10^4。這個0.11*10^4 * (可變10khm)=1.1V. 所以範圍就從0到1V了。此外我發現到假設有固定的電阻值，如果在固定的電阻值上再加上越大的電阻，總體的電流雖然變小，但是剛加上的電阻由於很大，分壓給剛加的電阻的電壓越大。這也是一種分壓方式啊。
</details>

<details>
<summary>ESP-32代碼除錯</summary>
我大概看了粗略地看過ESP-32 datasheet 之後還是沒明白爲什麽有些GPIO 會影響OUTPUT 的輸出。總之在做ESP-32專題的時候除錯時先不管3721改變GPIO 接脚就對了。可能是本人對於ESP-32 用的不多，使用ARDUINO 的時候也只碰過一次類似的事情。
</details>

<details>
<summary>焊接原理</summary>
我使用到的焊接工具主要為：
- 焊槍 
- 焊接機：提供電流進行焊接的主要設備
- 焊條
- 鋼絲刷： 用於清潔焊接表面
我學到了原來焊接的時候如果不清理表面已經不熱的錫，由於缺少助焊劑，焊接的時候不能有效的把手持的焊條焊進理想的區域。這是因爲錫的性質融化后會想要去熱的地方。因此在焊接前可以先把一小部分的焊條在黏附在焊槍的表面，趁表面還熱的時候趕緊將手持的焊條往理想區域焊接，焊條會自動走向焊槍表面上黏附的錫。
</details>

<details>
<summary> 耳機的原理</summary>
助教講了之後我才發現原來耳機插頭的結構是有原因的：
插頭結構：
    Tip（頂端）：通常為左聲道
    Ring（環）：通常為右聲道
    Sleeve（套筒）：通常為共地（GND）
</details>