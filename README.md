# 🩸 libre-view.nvim

A lightweight, asynchronous **Neovim 0.12+** Lua plugin to monitor real-time glucose levels from **FreeStyle Libre** sensors via the **LibreLinkUp** API, directly inside your `bufferline.nvim`.

![Neovim Version](https://img.shields.io/badge/Neovim-0.12%2B-57A143?logo=neovim&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Lua](https://img.shields.io/badge/Lua-5.1%20%2F%20JIT-2C2D72?logo=lua&logoColor=white)
![GitHub Release](https://img.shields.io/github/v/release/TU_USERNAME/libre-view.nvim?color=brightgreen)

---

> ⚠️ **DISCLAIMER & LEGAL NOTICE**
> 1. **No Commercial Affiliation:** This project is **NOT** affiliated, associated, authorized, endorsed by, or in any way officially connected with **Abbott Laboratories**, **FreeStyle Libre**, **LibreLinkUp**, or any of its subsidiaries or affiliates.
> 2. **Personal & Educational Use Only:** This plugin was developed strictly for personal, educational, and experimental purposes.
> 3. **Not a Medical Device:** **`libre-view.nvim` IS NOT A MEDICAL DEVICE** or diagnostic tool. Do not make medical or dosing decisions based on values displayed in this editor widget. Always consult official medical applications approved by health authorities.

---

## ✨ Features

- **Non-blocking Asynchronous Fetching:** Built with Neovim 0.12+ native `vim.uv` and `vim.system()` to prevent UI freezes.
- **SHA-256 Authentication:** Implements Abbott's required header security hash verification.
- **Bufferline Integration:** Seamlessly embeds as a custom right-aligned widget in `bufferline.nvim`.
- **Region Support:** Configurable endpoints for US, EU, LatAm (CL), and Asia.

---

## 📦 Installation & Setup

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  {
    "themakunga/libre-view.nvim",
    opts = {
      email = "your_follower_email@example.com",
      password = "your_password",
      region = "cl", -- Options: "cl" (LatAm), "eu", "us", "ae"
      update_interval = 300, -- Interval in seconds (5 minutes)
    },
  },
}

### Using vim.pack

```lua
{
  vim.pack.add({
    {src = 'https://github.com/themakunga/libre-view.nvim'}
  })

  libre-view.setup({
     email = "your_follower_email@example.com",
      password = "your_password",
      region = "cl", -- Options: "cl" (LatAm), "eu", "us", "ae"
      update_interval = 300, -- Interval in seconds (5 minutes)
  })
}
```

### Integration with bufferline.nvim

Add the widget to the custom_areas option in your bufferline configuration:


```lua
require("bufferline").setup({
  options = {
    custom_areas = {
      right = function()
        local libre = require("libre-view")
        return {
          {
            text = libre.widget(),
            fg = "#7dcfff", -- Tokyo Night cyan accent
            bg = "#1f2335",
            bold = true,
          },
        }
      end,
    },
  },
})
```

## ⚙️ Configuration Options

| Option | Type| Default | Description |
| --- | --- | --- | --- |
| email | string | "" | LibreLinkUp follower account email |
| password | string | ""|LibreLinkUp follower account password |
| region | string | "cl" | "Endpoint region (cl, latam, eu,  us, ae)" |
| update_interval | number | 300 | Fetch interval in seconds |


## 🤝 Contributing
Contributions are welcome! Please make sure to follow standard Lua formatting and verify commit hooks before submitting a Pull Request.

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.
