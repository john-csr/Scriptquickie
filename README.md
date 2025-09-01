

# Scriptquickie

## Overview

**Scriptquickie** is a lightweight HTA-based GUI tool for Windows that simplifies the loading, editing, and execution of PowerShell scripts. It also includes a folder file lister for quick inspection and launching of scripts from selected directories.

Built for AV/IT professionals and sysadmins who need a fast, local-only interface for managing `.ps1` scripts without relying on external dependencies or bloated IDEs.

Watch the demo on [YouTube](https://youtu.be/CsOimc8axL0)

---

## Features

- **Script Loader**: Load `.ps1` files into an editable text area  
- **Script Runner**: Execute scripts with elevated privileges via PowerShell  
- **Script Saver**: Save edited scripts back to disk  
- **Folder Selector**: Browse and select folders using native Windows shell  
- **File Lister**: Display all files in the selected folder  
- **Direct File Launcher**: Run any file in the selected folder with elevation  
- **Fixed Script Launcher**: Auto-locate and run `PSscriptLauncher.ps1` from the HTA directory  
- **Explorer Integration**: Open selected folder directly in Windows Explorer  

---

## UI Layout

| Panel         | Description                                                                 |
|---------------|-----------------------------------------------------------------------------|
| Left Panel    | Script Loader: Load, edit, run, and save `.ps1` scripts                     |
| Right Panel   | Folder File Lister: Select folder, view contents, launch files, open Explorer |

---

## Security Notes

- Uses `ShellExecute` with `"runas"` to ensure elevated execution  
- Scripts are written to `%TEMP%` before execution to avoid modifying originals  
- No external libraries or internet access required—fully local and secure  

---

## Requirements

- Windows OS with HTA support (Windows 7 or later)  
- PowerShell installed  
- ActiveX enabled (default in HTA environments)  

---

## Usage Instructions

1. Launch `Scriptquickie.hta` by double-clicking it  
2. Use the **left panel** to load and run `.ps1` scripts  
3. Use the **right panel** to browse folders and inspect contents  
4. Launch scripts directly or open folders in Explorer  

---

## Suggested File Structure

```
Scriptquickie/
├── Scriptquickie.hta
├── PSscriptLauncher.ps1
├── README.md
└── /scripts
    ├── cleanup.ps1
    └── deploy.ps1
```

---

## Author Info

- Created by: John C.  
- Version: 1.0  
- Date: August 9, 2025  
- Purpose: Rapid script testing and deployment in classroom and enterprise AV/IT environments  




