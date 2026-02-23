`timescale 1ns/1ps

module full_system_tb();
bit SYS_FCLK1;
bit SYS_FCLK2;
bit SYS_RESETn1;
bit SYS_RESETn2;
bit phy_ble_clk1;
bit phy_ble_clk2;

localparam CLK = 10;
localparam BLE = 18;

full_system DUT(.*);
initial begin
    SYS_FCLK1 = 0;
    forever begin
        #(CLK/2.0) SYS_FCLK1 = !SYS_FCLK1;
    end
end

initial begin
    SYS_FCLK2 = 0;
    forever begin
        #(CLK/2.0) SYS_FCLK2 = !SYS_FCLK2;
    end
end

initial begin
    phy_ble_clk1 = 0;
    forever begin
        #(BLE/2.0) phy_ble_clk1 = !phy_ble_clk1;
    end
end
initial begin
    phy_ble_clk2 = 0;
    forever begin
        #(BLE/2.0) phy_ble_clk2 = !phy_ble_clk2;
    end
end

initial begin
    SYS_RESETn1 = 0;
    SYS_RESETn2 = 0;
    #100;
    SYS_RESETn1 = 1;
    SYS_RESETn2 = 1;
    #20_000_000;
    $stop;
end

endmodule