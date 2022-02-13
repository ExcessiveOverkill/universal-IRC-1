const
N054VendorID = $10B5;
N054DeviceID = $9054;

N054PCICR = $04;            { PCI Status and control Register }
N054PCIBaseAddress0 = $10;  { memory access to local config regs }
N054PCIBaseAddress1 = $14;  { I/O access to local config regs }
N054PCIBaseAddress2 = $18;  { local address space 0 }
N054PCIBaseAddress3 = $1C;  { local address space 1 }
N054PCIIntRegister  = $3C;  { interrupt routing register }
N054GPIOControlReg = $6C;
N054GPIOControlRegTop = $6E;

{ at N054GPIOControlRegTop }
N054UserOMask = $0001;
N054UserIMask = $0002;
N054UserIIsInputMask : word = $0004;
N054UserOIsOutputMask : word = $0008;

N054EECLKMask : word = $0100;
N054EECSMask : word = $0200;
N054EEDIMask : word = $0400;
N054EEDOMask : word = $0800;

{ 4I68/5I21/5I22/5I23 Specific masks for access to PCI bridge GPIO bits... }

DoneMask_54 : word    = N054UserIMask; { Read at N054GPIOControlRegTop}
ProgramMask_54 : word = N054UserOMask; { Written at N054GPIOControlRegTop}

{DMA registers}

N054DMAMode0Register = $80;
N054DMAPAdr0Register = $84;
N054DMALAdr0Register = $88;
N054DMASiz0Register = $8C;
N054DMADPr0Register = $90;
N054DMACSR0Register = $A8;  {Byte register!}
N054DMADAC0Register = $B4;

N054DMAMode1Register = $94;
N054DMAPAdr1Register = $98;
N054DMALAdr1Register = $9C;
N054DMASiz1Register = $A0;
N054DMADPr1Register = $A4;
N054DMACSR1Register = $A9;  {Byte register!}
N054DMADAC1Register = $B8;

N054DMAThrRegister = $B0;
