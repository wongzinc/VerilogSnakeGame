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
