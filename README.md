# SoterFixer
Fixes the SOTER key failure caused by unlocking the bootloader on OnePlus Snapdragon devices.
SOTER Key Repair Module - OnePlus Universal Edition | CoolAPK @XiaoHuangBo
This module is completely free. Reselling it is shameful!!!!
This archive contains two modules:
1.	Magisk/ - Magisk module
2.	KernelSU/ - KernelSU module
   
Please install the corresponding module based on your root solution:
Magisk users:

⦁	Install the Magisk/module.prop directory in the Magisk App, or flash the .zip file directly

KernelSU users:

⦁	Install the KernelSU/module.prop directory in the KernelSU App, or flash the .zip file directly

Module features:
⦁	Automatically runs the SOTER Key repair script after boot

⦁	Executes every 5 seconds

⦁	Silent operation, no log output

Repair contents:

⦁	Stops the vendor.soter service

⦁	Clears app data of com.tencent.soter.soterserver

⦁	Restarts the vendor.soter service

⦁	Fixes the SOTER Key freeze caused by bootloader unlock (reversible; no side effects after uninstalling the module)
# FAQ
⚠️⚠️ Note: This module only works when combined with a custom-flashed TEE (tutorial [https://www.coolapk.com/feed/60393556 ]). Be aware that the TEE flashing process is irreversible. After flashing the TEE, install this module and you will get a nearly perfect TEE with an all-green key status! 😋

If the module does not seem to work: its effectiveness is probabilistic. Manually run the fix_soter_key.sh script inside the module .zip, then try again without rebooting and check whether it succeeds; if not, run it a few more times.
If it still fails, the problem is that you have not flashed the TEE following this tutorial https://www.coolapk.com/feed/60393556. Flash the TEE first, then come back (note that the flashing operation is irreversible).
![Screenshot_2025-10-13-23-28-53-91_40dbc481ca5b738a325e5182fc08a331](https://github.com/user-attachments/assets/03d2af91-b4b0-4bbe-a422-363d34af9447)

# How to bypass Chunqiu's "Untrusted TEE environment" check and duckdetector's sotercheck
Chunqiu and duckdetector recently updated their SoterKey detection. OnePlus devices with unlocked bootloaders will trigger "Untrusted TEE environment" and "sotercheck" errors. This can be resolved with a downgrade attack.
Required modules:

TEESimulator-RS: https://github.com/Enginex0/TEESimulator-RS

AiWanJi Toolbox (or Hail also works): https://github.com/aistra0528/Hail

SoterkeyFixer (this project)

After installing SoterkeyFixer and TEESimulator-RS, open Hail or AiWanJi Toolbox - Apps - App Management - search for "SoterService" [com.tencent.soter.soterserver] - Freeze/Unfreeze - freeze it directly.
No reboot needed — the SoterKey check will pass right away. The principle is a downgrade attack plus service blocking.
```
Before:
App → Soterkey → TEE → Strict verification ❌

Now:
App → Soterkey ❌ (frozen)
↓ fallback
Software verification / Default values → ✅
```
**This is the fundamental reason why the "downgrade attack + service blocking" combo can bypass Chunqiu/DuckDetector's new SoterKey detection** (targeting OnePlus devices with unlocked bootloaders, especially Android 16 models like the OnePlus PJZ110).

### 1. Root cause: why does unlocking a OnePlus device trigger "Untrusted TEE environment" + Soter check failure?
- **Soter** is Tencent's proprietary security key framework **based on TEE (Trusted Execution Environment)** (keystore + biometrics). Payment/banking apps such as WeChat Pay rely heavily on it for hardware-level security.
- After **Bootloader unlock**, the hardware TEE's **attestation certificate chain** on OnePlus devices (OxygenOS/ColorOS) gets marked as **revoked/untrusted** by the system's/Google's/Tencent's **online revocation list**.  
  → The Network section clearly shows: "This certificate chain matched 1 revoked/suspended entry."  
  → The Soter check then reports errors such as `finalErr=4`, `signing=skipped`, `removeAskSkipped=false`.
- Chunqiu Native check-Eros 3.1 and DuckDetector were **recently updated** specifically to strengthen **SoterKey detection**: they no longer just look at root/hooks, but actively call SoterService for integrity verification → straight-up red text "System compromised" + "Untrusted TEE environment".

### 2. Why do the module + freezing instantly pass the check? (core principle)
The three tools together **kill off or fake every step** of Soter's detection path:

| Step | Before (failed) | Now (success) | Principle |
|------|-------------|-------------|------|
| **TEESimulator-RS** | Real TEE revoked | The module fully emulates the TEE at the **keystore2 ioctl** layer, generating a **fake valid certificate chain** | Makes upper layers believe the TEE is still "clean" |
| **SoterkeyFixer** | Soter key corrupted | A repair module written specifically for OnePlus Snapdragon devices (stops the vendor.soter service + patches keys) | Specifically handles OnePlus SoterKey compatibility issues after unlock |
| **Freezing SoterService**<br>(com.tencent.soter.soterserver) | Service runs normally → check passes | **Frozen outright** | Detection tools **cannot connect to the Treble service** → forced onto the **downgrade path** |

- The essence of the **"downgrade attack"**: **make the Soter service unreachable** → the detection logic directly **skips** all strict checks:
  1. Init & service → skipped (coreType=0, trebleConnected=false)
  2. Biometric capability → skipped (no hardware/not enrolled)
  3. Key preparation → skipped (device does not support SOTER)
  4. Signing session → skipped
  5. Cleanup → executed (removeAskSkipped=true)

-  **Soter check skipped because the Treble service was not reachable** is exactly the hallmark of freezing taking effect.
- "Normal" + "No high risk found" happens because all Soter steps become "skipped"; the new detection judges this state as **safe** (by design, for compatibility with older devices).

### 3. Why does it take effect without a reboot?
- Freezing takes effect **immediately** (the LSPosed/KernelSU layer directly kills + denies the service).
- TEESimulator-RS and SoterkeyFixer are **LSPosed/KernelSU modules** injected at Zygote level; they have already taken over keystore/TEE calls at runtime.

**In one sentence**:  
This is not "repairing" the TEE — it is **using modules to fake a clean TEE + completely blocking the real SoterService**, so Chunqiu's detection tools **cannot get any failure data at all** and only see a bunch of "skips", judging the result as Normal.

This is the classic **service downgrade + environment emulation** bypass — currently the most stable solution for OnePlus devices (other brands may not need SoterkeyFixer).  
When Chunqiu updates again in the future, as long as freezing + these two modules remain in place, it basically will not break.

https://www.coolapk.com/feed/71065685
