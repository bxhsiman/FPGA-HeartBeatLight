# 在小脚丫FPGA上实现不同的LED显示效果
## 任务简介
在小脚丫FPGA核心板上，利用8个单色LED实现不同的LED显示效果，通过4个轻触按键控制不同的LED显示模式，通过4个拨动开关控制每种显示模式的显示周期，并在数码管上通过数值显示出相应的模式和周期 - 第一个数码管显示LED的显示模式，第二个数码管显示周期。

## 功能介绍
### 轻触开关K1 ～ K4，用于切换LED的显示模式：
- K1: 循环心跳灯 - 8个LED轮流心跳，每一个LED心跳2个周期（半个周期亮、半个周期灭、半个周期亮、半个周期灭），然后该LED灭掉，下一个LED开始跳动，从第一个LED开始，到第8个LED，然后再从第一个开始，周而复始，其心跳的周期由拨动开关SW1～SW4控制
- K2: 呼吸灯 - 8个LED轮流呼吸，每一个LED呼吸2个周期（半个周期从灭到亮、半个周期从亮到灭、半个周期从灭到亮、半个周期从亮到灭），然后该LED灭掉，下一个LED开始呼吸，从第一个LED开始，到第8个LED，然后再从第一个开始，周而复始，其呼吸的周期由拨动开关SW1～SW4控制
- K3: 带渐灭功能的流水灯 - 8个LED构成流动显示的效果，且下面的灯亮度逐渐变暗
- K4: 自定义模式 - 自己设计一种不同样能够让8颗LED点亮的模式

### 拨动开关，用于控制显示的周期：
- SW1: 1秒
- SW2: 2秒
- SW3: 3秒
- SW4: 4秒

## 需求分析
本次任务大致可分为一组输出(显示部分)和一组输入部分(控制部分)，每个部分均有两个子模块具体分析如下：
### 显示部分
#### LED显示模块
本系统需要支持以下四种LED显示模式：
1. **循环心跳灯**：8个LED轮流心跳，每个LED有两个周期（一个周期亮、一个周期灭），然后切换到下一个LED，周期可通过拨动开关设置。
2. **呼吸灯**：8个LED轮流呼吸，每个LED有两个周期（一个周期从灭到亮、一个周期从亮到灭），然后切换到下一个LED，周期可通过拨动开关设置。
3. **带渐灭功能的流水灯**：8个LED构成流动显示的效果，且下面的灯亮度逐渐变暗，速度可通过拨动开关设置。
4. **自定义模式**：用户可自行设计一种LED点亮的模式。
在本次任务实现当中，自定义模式被设计为**爆闪灯**，即前4个灯以1/6个周期速度快速闪烁三次，随后后四个灯以1/6个周期速度快速闪烁三次，以此循环
#### 数码管显示模块
1. 第一个数码管显示当前LED的显示模式，即K1～K4进行的选择。
2. 第二个数码管显示当前LED的显示周期，即SW1-4进行的选择。
3. 当输入无效时，需要进行提醒。

### 控制部分
#### 轻触开关
使用四个轻触开关k1-k4控制LED的显示模式。
#### 拨码开关
使用四个拨动开关sw1-sw4控制LED运行的周期。

### 其他要求
#### 软硬件平台要求
使用小脚丫FPGA核心板，基于[webIDE](https://www.stepfpga.com/)进行综合，仿真，管脚映射与烧录。

## 功能实现方式
### 显示功能
### LED显示模块
1. 本次任务的灯都是依次点亮的，对于LED灯的选择，可以实现一个状态机分别对应8个灯，指示当前应当点亮哪个灯。
2. 对于LED的总的周期控制，需要实现一个分频器，根据`周期选择寄存器`的值将时钟分频为合适的速率输入LED驱动模块。
3. 对于显示功能的选择，需要实现一个MUX，根据`模式选择寄存器`的值，将8个LED灯接到合适的位置。
4. LED驱动模块将分为四个子模块，分别实现上述的四个功能：
   1. **循环心跳灯**：输入时钟的一半时间输出高，一半时间输出低。
   2. **呼吸灯**: 实现一个PWM生成器，输入时钟前一半时间每一次电平反转阈值+1，后一半时间每一次电平反转阈值-1。
   3. **带熄灭功能的流水灯**：实现8个PWM生成器，生成一个状态机控制当前选择的灯珠，将当前选择灯珠的PWM Duty设置为100，其余灯珠依次减小。
   4. **爆闪灯**：将灯分为两组，输入时钟进行2分频用于选择灯组，再6分频用于点亮熄灭灯组。
### 数码管显示模块
实现一个译码器，显示当前模式选择寄存器与周期选择寄存器的信息，如果有效则显示有效值，如果无效显示提示。

### 控制功能
创建一个模式选择寄存器，一个周期选择寄存器。对于拨码开关，可以直接将值对应到周期选择器。对于按键开关，需要设计一个锁存器，锁住选择值。

## 硬件框图
![硬件框图](/doc/image/modules.png)

## 代码简介
``` c
top.v [顶层模块]
   |---clk_divider.v [时钟分频器]
   |---driver_selector.v [驱动选择器]
   |     |--- mode1.v [心跳灯驱动]
   |     |--- mode2.v [呼吸灯驱动]
   |     |--- mode3.v [流水灯驱动]
   |     |--- mode4.v [爆闪灯驱动]
   |---key.v [按键开关译码器]
   |---sw.v  [拨码开关译码器]
   |---rst.v [复位]
   |---seg.v [数码管译码器]
```
### `clk_divider.v` 时钟分频器 
#### 代码内容
``` v
module clk_divider 
#(
   parameter   clk_freq = 12_000_000 // 12MHz
) 
(
    input         clk,
    input         rst_n,
    input [3:0]   period, // 4'd1: 240000Hz, 4d'2: 120000Hz, 4d'3: 80000Hz, 4d'4: 60000Hz 
    output reg    clk_out
);
    reg [31:0] counter;
    reg [31:0] period_values [3:0];

    // Initialize period values
    initial begin
        period_values[0] = clk_freq / 240000 / 2;
        period_values[1] = clk_freq / 120000 / 2;
        period_values[2] = clk_freq / 80000 / 2;
        period_values[3] = clk_freq / 60000 / 2;
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 0;
            clk_out <= 0;
        end
        else begin
            counter <= counter + 1;
            case (period)
                4'd1: begin
                    if (counter == period_values[0]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                4'd2: begin
                    if (counter == period_values[1]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                4'd3: begin
                    if (counter == period_values[2]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                4'd4: begin
                    if (counter == period_values[3]) begin
                        counter <= 0;
                        clk_out <= ~clk_out;
                    end
                end
                default: begin
                    counter <= 0;
                    clk_out <= 0;
                end
            endcase
        end
    end
endmodule

```
本模块`initial`块中进行了频率对应计数值的计算，随后当`clk计数器`达到计数值时反转电平。通过输入的`period`选择对应频率的计数值。
#### 仿真结果：
![clk_divider波形图](/doc/sim/tb_clk_divider.png)

放大可见分频符合要求，符合设计。

---
### `driver_selector.v` 驱动选择器
#### 代码内容：
``` v   
//闪灯模式选择器
//create by siman 2024/3/11

module driver_selector(
    input clk,
    input rst_n,
    input [3:0]  mode_select, // 4'b0001: Mode1, 4'b0010: Mode2, 4'b0011: Mode3, 4'b0100: Mode4
    output reg [7:0]  signal 
);
    wire [31:0] dirvers_signal;

    //implennt the drivers 
    LED_mode1_driver driver1(
        .clk(clk),
        .rst_n(rst_n),
        .led_out(dirvers_signal[7:0])
    );
    LED_mode2_driver driver2(
        .clk(clk),
        .rst_n(rst_n),
        .led_out(dirvers_signal[15:8])
    );
    LED_mode3_driver driver3(
        .clk(clk),
        .rst_n(rst_n),
        .led_out(dirvers_signal[23:16])
    );
    LED_mode4_driver driver4(
        .clk(clk),
        .rst_n(rst_n),
        .led_out(dirvers_signal[31:24])
    );

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            signal <= 8'b1111_1111;
        end
        else
            case (mode_select)
                4'b0001: begin
                    signal <= ~dirvers_signal[7:0];
                end
                4'b0010: begin
                    signal <= ~dirvers_signal[15:8];
                end
                4'b0011: begin
                    signal <= ~dirvers_signal[23:16];
                end
                4'b0100: begin
                    signal <= ~dirvers_signal[31:24];
                end
                default: begin
                    signal <= 8'b1111_1111;
                end
            endcase
    end

endmodule   
```
本模块中例化全部驱动，根据`mode_select`的值选择对应例化mode的信号进行输出。
#### 仿真结果：
**模式1**

![tb_driver_sel-1](/doc/sim/tb_driver_sel-1.png)

**模式2**

![tb_driver_sel-2](/doc/sim/tb_driver_sel-2.png)

**模式3**

![tb_driver_sel-3](/doc/sim/tb_driver_sel-3.png)

**模式4**

![tb_driver_sel-4](/doc/sim/tb_driver_sel-4.png)

**输入无效**

![tb_driver_sel-5](/doc/sim/tb_driver_sel-5.png)

---
### `key.v` 按键开关译码器
#### 代码说明：
``` v
//按钮锁存模块
//created by siman 2024/3/11

module key (
    input clk,
    input rst_n,
    input [3:0] key_in,
    output reg [3:0] key_out
);
    reg [3:0] last_valid_value;
    
    initial begin
        last_valid_value = 4'b0001;
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            key_out <= 4'b0001; // default value
            last_valid_value <= 4'b0001; 
        end
        else begin
            case (~key_in) 
                4'b0001: begin 
                    key_out <= 4'b0001;
                    last_valid_value <= 4'b0001;
                end
                4'b0010: begin 
                    key_out <= 4'b0010;
                    last_valid_value <= 4'b0010;
                end
                4'b0100: begin 
                    key_out <= 4'b0011;
                    last_valid_value <= 4'b0011;
                end
                4'b1000: begin 
                    key_out <= 4'b0100;
                    last_valid_value <= 4'b0100;
                end
                4'b0000: begin // keep the last valid value
                    key_out <= last_valid_value;
                end
                default: begin // if input is invalid, display F
                    key_out <= 4'b1111; // 显示F
                end
            endcase
        end
    end

endmodule
```
本模块创建了一个寄存器，`key_in`值输入非全0时更新`key_out`的值，实现锁存功能
#### 仿真结果：
![tb_key](/doc/sim/tb_key.png)

可见成功锁存并译码。默认值1，当输入无效时输出F，符合设计。

---
### `sw.v` 拨码开关译码器
#### 代码内容：
``` v
//拨码开关译码模块
// created by siman 2024/3/12
module sw(
    input [3:0] sw_i,
    output reg [3:0] sw_o
);

    always @(*) begin
        case (sw_i)
            4'b0001: sw_o = 4'b0001; 
            4'b0010: sw_o = 4'b0010; 
            4'b0100: sw_o = 4'b0011; 
            4'b1000: sw_o = 4'b0100; 
            default: sw_o = 4'b1111; // if input is invalid, display F
        endcase
    end

endmodule

```
本模块将输入信号译码，输出为0-4的值。(seg译码器接受正常二进制，本任务`sw_i`并不是按照正常二进制表示的数字)
#### 仿真结果：
![tb_sw](/doc/sim/tb_sw.png)

可见译码正确，符合设计。

---

### `rst.v` 复位
#### 代码内容：
``` v
//复位逻辑
//created by siman 2024/3/12

module rst(
    input [3:0] key_input,
    output rst_n
);

assign rst_n = (key_input == 4'b0000) ? 1'b0 : 1'b1;

endmodule
```
本模块实现了一个4bit查找表，仅输入`4'b0000`时~rst有效。
#### 仿真结果：
![tb_rst](/doc/sim/tb_rst.png)

可见仅输入`4'b0000`时~rst有效，符合设计。

---
### `seg.v` 数码管译码器
#### 代码内容：
``` v
//段码屏译码模块
//by ChatGpt 2024/2/06
module seg_display (
    input clk,
    input rst_n,
    input [7:0] value,  // 8-bit input value (0-255) 
    output [8:0] seg1,  // 9-segment display for the first digit
    output [8:0] seg2   // 9-segment display for the second digit
);
    reg [7:0] value_reg;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            value_reg <= 8'hFF;
        end
        else begin
            value_reg <= value;
        end
    end
    // 4-bit values for each hex digit
    wire [3:0] digit1 = value_reg[7:4]; // High nibble
    wire [3:0] digit2 = value_reg[3:0]; // Low nibble

    // Convert 4-bit values to 9-segment display
    nine_seg_decoder decoder1(.binary_value(digit1), .seg(seg1));
    nine_seg_decoder decoder2(.binary_value(digit2), .seg(seg2));

endmodule

// Module to convert 4-bit binary to 9-segment display
module nine_seg_decoder (
    input [3:0] binary_value,
    output reg [8:0] seg
);

    // Convert binary to 9-segment (assuming common anode display)
    always @(binary_value) begin
        case (binary_value)
            4'h0: seg = 9'b111111000; // 0
            4'h1: seg = 9'b011000000; // 1
            4'h2: seg = 9'b110110100; // 2
            4'h3: seg = 9'b111100100; // 3
            4'h4: seg = 9'b011001100; // 4
            4'h5: seg = 9'b101101100; // 5
            4'h6: seg = 9'b101111100; // 6
            4'h7: seg = 9'b111000000; // 7
            4'h8: seg = 9'b111111100; // 8
            4'h9: seg = 9'b111101100; // 9
            4'hA: seg = 9'b111011100; // A
            4'hB: seg = 9'b001111100; // b
            4'hC: seg = 9'b100111000; // C
            4'hD: seg = 9'b011110100; // d
            4'hE: seg = 9'b100111100; // E
            4'hF: seg = 9'b100011100; // F
            default: seg = 9'b000000001; // Blank display for undefined values
        endcase
    end
endmodule

```
本模块将输入信号译码，分别显示到两个段码屏上。

#### 仿真结果：
![tb_seg](/doc/sim/tb_seg.png)

可见译码正确，符合设计。

---
### `mode1_heart_beat.v` 心跳灯
#### 代码内容：
``` v
//心跳灯驱动
// Created by siman 2024/3/11

module LED_mode1_driver 
#(
    parameter PERIOD = 240000  //1s BASE PERIOD
) 
(
    input clk,
    input rst_n,
    output reg [7:0] led_out
);

    reg [31:0] counter = 0; 
    reg [2:0] current_led = 0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 32'd0;
            current_led <= 8'd0;
            led_out <= 8'b0000_0000; 
        end
        else begin
            if (counter < PERIOD / 4) begin
                led_out <= 1 << current_led;
                counter <= counter + 1;
            end
            else if (counter >= PERIOD / 4 && counter < PERIOD / 2) begin
                led_out <= 8'b0000_0000;
                counter <= counter + 1;
            end
            else if (counter >= PERIOD / 2 && counter < PERIOD / 4 * 3) begin
                led_out <= 1 << current_led;
                counter <= counter + 1;
            end
            else if (counter >= PERIOD / 4 * 3 && counter < PERIOD) begin
                led_out <= 8'b0000_0000;
                counter <= counter + 1;
            end
            else begin
                counter <= 32'd0;
                current_led <= current_led + 1;
                if (current_led >= 7) begin
                    current_led <= 8'd0;
                end
            end
        end
    end
endmodule

```
本模块中创建了一个计数器，当计数值每达到1/4周期时，将改变电平，完成在一个周期闪烁两次的任务。当计数器达到1周期时，将进行灯的切换。

#### 仿真结果：
![tb_mode1](/doc/sim/tb_mode1.png)
可见一个周期同LED闪烁两次，时序正确。

---
### `mode2_breath.v` 呼吸灯
#### 代码内容：
``` v
//呼吸灯驱动
//create by siman 2024/3/11

module LED_mode2_driver
#(
    parameter PERIOD = 240000  //1s BASE PERIOD
)
(
    input clk,
    input rst_n,
    output reg [7:0] led_out
);
    reg [31:0] counter = 0; 
    reg [2:0] current_led = 0; 
    
    reg [31:0] duty;
    reg [31:0] duty_counter; 

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            duty = 32'd0;
            counter = 12'd0;
            current_led = 8'd0;
        end
        else begin
            if (counter <= PERIOD / 4) begin
                // First PERIOD / 4 cycles, the LED duty cycle increases
                counter = counter + 1;
                if(counter % 60 == 0) begin
                    duty = duty + 1;
                end
            end
            else if (counter > PERIOD / 4 && counter <= PERIOD / 2) begin
                // The next PERIOD / 4 cycles, the LED duty cycle decreases
                counter = counter + 1;
                if(counter % 60 == 0) begin
                    duty = duty - 1;
                end
            end
            else if (counter > PERIOD / 2 && counter <= PERIOD / 4 * 3) begin
                // The next PERIOD / 4 cycles, the LED duty cycle increases
                counter = counter + 1;
                if(counter % 60 == 0) begin
                    duty = duty + 1;
                end
            end
            else if (counter > PERIOD / 4 * 3 && counter < PERIOD) begin
                // The next PERIOD / 4 cycles, the LED duty cycle decreases
                counter = counter + 1;
                if(counter % 60 == 0) begin
                    duty = duty - 1;
                end
            end
            else if (counter == PERIOD) begin
                counter = 32'd0;
                current_led = current_led + 1;
            end

        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            led_out = 8'b0000_0000;
            duty_counter = 32'd0;
        end
        else begin
            duty_counter = duty_counter >= PERIOD / 8 / 60  ? 0 : duty_counter + 1;
            led_out = (duty_counter <= duty) ? (1 << current_led) : (8'b0000_0000); 
        end
    end
endmodule
```
本模块中创建了一个计数器，一个pwm发生器，当计数值每达到1/4周期时，将改变pwm发生器的duty变化方向，实现由亮到暗再由暗到亮。当计数器达到1周期时，将切换接入到pwm发生器的led，完成灯的切换。

#### 仿真结果：
**整体波形**

![mode2整体波形](/doc/sim/tb_mode2-1.png)

**调光细节**

![mode2调光细节](/doc/sim/tb_mode2-2.png)
可见PWM占空比由大到小，再由小到大，LED切换正常，符合设计。

---
### `mode3_water_flow.v` 流水灯
#### 代码内容：
``` v
module LED_mode3_driver(
    input clk,
    input rst_n,
    output reg [7:0] led_out
);

reg [31:0] counter = 0;
reg [31:0] pwm_counter[7:0];
reg [31:0] pwm_duty[7:0];
reg [2:0] current_led = 0;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        current_led <= 0;
        for (i = 0; i < 8; i++) begin
            pwm_duty[i] <= 0;
        end
    end 
    else begin
        if (counter >= 30000) begin
            counter <= 0;
            current_led <= (current_led - 1) % 8; // change to next led
            pwm_duty[current_led] <= 900; 
            pwm_duty[(current_led + 1) % 8] <= pwm_duty[(current_led + 1) % 8] > 50 ? pwm_duty[(current_led + 1) % 8] - 250 : 0;
            pwm_duty[(current_led + 2) % 8] <= pwm_duty[(current_led + 2) % 8] > 50 ? pwm_duty[(current_led + 2) % 8] - 250 : 0;
            pwm_duty[(current_led + 3) % 8] <= pwm_duty[(current_led + 3) % 8] > 50 ? pwm_duty[(current_led + 3) % 8] - 100 : 0;
            pwm_duty[(current_led + 4) % 8] <= pwm_duty[(current_led + 4) % 8] > 50 ? pwm_duty[(current_led + 4) % 8] - 100 : 0;
            pwm_duty[(current_led + 5) % 8] <= pwm_duty[(current_led + 5) % 8] > 50 ? pwm_duty[(current_led + 5) % 8] - 50 : 0;
            pwm_duty[(current_led + 6) % 8] <= pwm_duty[(current_led + 6) % 8] > 50 ? pwm_duty[(current_led + 6) % 8] - 50 : 0;
            pwm_duty[(current_led + 7) % 8] <= pwm_duty[(current_led + 7) % 8] > 50 ? pwm_duty[(current_led + 7) % 8] - 50 : 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
end

// PWM OUTPUT
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 8; i++) begin
            pwm_counter[i] <= 0;
        end
        led_out <= 0;
    end else begin
        for (i = 0; i < 8; i++) begin
            pwm_counter[i] <= pwm_counter[i] >= 900 ? 0 : pwm_counter[i] + 1;
            led_out[i] <= (pwm_counter[i] < pwm_duty[i]) ? 1 : 0;
        end
    end
end

endmodule

```
本模块中创建了1个计数器，8个pwm控制器，1个led选择寄存器。当计数值达到1周期时，将向后led选择寄存器的值，并且减小选中led前方7个pwm控制器的duty，实现渐灭流水灯的效果。

#### 仿真结果：
**整体波形**

![tb_mode3-1](/doc/sim/tb_mode3-1.png)

**调光细节**

![tb_mode3-2](/doc/sim/tb_mode3-2.png)

可见LED依次点亮，pwm占空比依次减小，符合设计。

---
### `mode4_blink.v` 爆闪灯
#### 代码内容：
``` v
//爆闪灯驱动
//create by siman 2024/3/11

module LED_mode4_driver 
#(
    parameter PERIOD = 240000 //1s BASE PERIOD
)
(
    input clk,
    input rst_n,
    output reg [7:0] led_out
);
    reg [31:0] counter;
    reg [7:0] led_mask; 

    // Generate the mask for the selected LED
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            led_mask = 8'b0;
        end
        else begin
            if (counter <= PERIOD / 2 + 1) begin
                led_mask = 8'b1111_0000;
            end
            else begin
                led_mask = 8'b0000_1111;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            led_out = 8'b0;
            counter = 32'd0;
        end
        else begin
            counter = counter + 1;
            if (counter % (PERIOD / 2 / 6) == 0) begin //CLK: 1200Hz / 6
                // Toggle the selected LED
                led_out = led_out ^ led_mask;
            end
            if (counter == PERIOD) begin
                counter = 32'd0;
            end
        end
    end 


endmodule  
```
本模块中创建了1个计数器，1个掩码寄存器，当周期达到1/2时切换掩码。当周期达到1/12的时候将切换掩码对应led的显示模式。
#### 仿真结果：
![tb_mode4](/doc/sim/tb_mode4.png)
可见LED分两组交替闪烁，符合设计。

---

## FPGA的资源利用说明
```
Design Summary
   Number of registers:    272 out of  4635 (6%)
      PFU registers:          264 out of  4320 (6%)
      PIO registers:            8 out of   315 (3%)
   Number of SLICEs:       496 out of  2160 (23%)
      SLICEs as Logic/ROM:    496 out of  2160 (23%)
      SLICEs as RAM:            0 out of  1620 (0%)
      SLICEs as Carry:        196 out of  2160 (9%)
   Number of LUT4s:        986 out of  4320 (23%)
      Number used as logic LUTs:        594
      Number used as distributed RAM:     0
      Number used as ripple logic:      392
      Number used as shift registers:     0
   Number of PIO sites used: 35 + 4(JTAG) out of 105 (37%)
   Number of block RAMs:  0 out of 10 (0%)
   Number of GSRs:        1 out of 1 (100%)
   EFB used :        No
   JTAG used :       No
   Readback used :   No
   Oscillator used : No
   Startup used :    No
   POR :             On
   Bandgap :         On
   Number of Power Controller:  0 out of 1 (0%)
   Number of Dynamic Bank Controller (BCINRD):  0 out of 6 (0%)
   Number of Dynamic Bank Controller (BCLVDSO):  0 out of 1 (0%)
   Number of DCCA:  0 out of 8 (0%)
   Number of DCMA:  0 out of 2 (0%)
   Number of PLLs:  0 out of 2 (0%)
   Number of DQSDLLs:  0 out of 2 (0%)
   Number of CLKDIVC:  0 out of 4 (0%)
   Number of ECLKSYNCA:  0 out of 4 (0%)
   Number of ECLKBRIDGECS:  0 out of 2 (0%)
   Notes:-
      1. Total number of LUT4s = (Number of logic LUT4s) + 2*(Number of
     distributed RAMs) + 2*(Number of ripple logic)
      2. Number of logic LUT4s does not include count of distributed RAM and
     ripple logic.
   Number of clocks:  2
     Net clk_c: 25 loads, 25 rising, 0 falling (Driver: PIO clk )
     Net clk_divided: 132 loads, 132 rising, 0 falling (Driver:

     clk_divider_inst/clk_out )
   Number of Clock Enables:  14
     Net driver_selector_inst/driver4/led_N_6_i: 4 loads, 4 LSLICEs
     Net driver_selector_inst/driver3/un1_counter_5_i: 5 loads, 5 LSLICEs
     Net driver_selector_inst/driver3/un1_counter_8_i: 5 loads, 5 LSLICEs
     Net driver_selector_inst/driver3/un1_counter_7_i: 5 loads, 5 LSLICEs
     Net driver_selector_inst/driver3/un1_counter_6_i: 5 loads, 5 LSLICEs
     Net driver_selector_inst/driver3/un1_counter_1_i: 5 loads, 5 LSLICEs
     Net driver_selector_inst/driver3/un1_counter_4_i: 5 loads, 5 LSLICEs
     Net driver_selector_inst/driver3/un1_counter_3_i: 5 loads, 5 LSLICEs
     Net driver_selector_inst/driver3/un1_counter_2_i: 5 loads, 5 LSLICEs
     Net driver_selector_inst/driver2/un1_counter_7lto11_RNIU6V8: 8 loads, 8
     LSLICEs
     Net driver_selector_inst/driver2/duty_0_sqmuxa_2: 7 loads, 7 LSLICEs
     Net driver_selector_inst/driver1/counter: 4 loads, 4 LSLICEs
     Net clk_divider_inst/N_10: 1 loads, 1 LSLICEs
     Net key_inst/un1_key_out16_3_i: 2 loads, 2 LSLICEs
   Number of local set/reset loads for net driver_selector_inst.rst_n_i_1 merged
     into GSR:  272
   Number of LSRs:  0
   Number of nets driven by tri-state buffers:  0
   Top 10 highest fanout non-clock nets:
     Net driver_selector_inst/driver3/current_led[2]: 211 loads
     Net driver_selector_inst/driver3/current_led[0]: 144 loads
     Net driver_selector_inst/driver3/current_led[1]: 130 loads
     Net driver_selector_inst/driver3/un230_pwm_dutylto10: 38 loads
     Net clk_divider_inst/N_10: 33 loads
     Net driver_selector_inst/driver3/un309_pwm_dutylto10: 32 loads
     Net driver_selector_inst/driver3/un151_pwm_dutylto10: 30 loads
     Net driver_selector_inst/driver3/counter: 21 loads
     Net driver_selector_inst/driver1/counter: 20 loads
     Net key_reg[1]: 18 loads

   Number of warnings:  1
   Number of errors:    0
```
整体资源占用情况良好，仍有较大余量。

## 演示视频
[Bilibili](https://www.bilibili.com/video/BV1rj421o7tM/?spm_id_from=333.1007.top_right_bar_window_history.content.click&vd_source=0568b29f4589991b763a5dabb8651c1e)

## 代码源文件
[Github](https://github.com/bxhsiman/FPGA-HeartBeatLight)


## 未来的计划与建议
在本次项目中我从小脚丫FPGA开始真正入门了FPGA开发，也意识到Verilog这种硬件描述语言与C等编程语言存在着彻底的差异。本项目中仍有很多嵌入式写法的代码造成资源浪费，希望未来能加以规避，真正学会FPGA。
感谢小脚丫与电子森林提供的机会，也希望你们越做越好！


(小脚丫的在线IDE十分方便，就是bug实在太多，比如管脚约束页内容时不时消失，填写管脚分配时如果填错，删除对应管脚后无法再选择... 建议做成在线可写的约束文档。在线实现的功能也有bug，lattice Diamond 离线可综合可实现的结构在线会报错，这也是本次项目后期没有使用在线IDE的原因。)
## 开发环境介绍

- IDE-Lattice Diamond
- Editor-VScode
- 仿真与波形显示-iverlog+GTKWave