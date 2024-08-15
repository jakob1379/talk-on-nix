# 🚀 Nix + Reveal.js Setup

## 📚 Overview
This project sets up a reproducible environment using **Nix** to develop presentations with **Reveal.js**. With this setup, you can easily clone the repo and start building and presenting without worrying about dependencies or configurations.

## 📦 Requirements
- Nix package manager

## 🛠️ Setup
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/jakob1379/talk-on-nix && cd talk-on-nix
   ```

2. **Enter the Nix Shell**:
   ```bash
   nix develop
   ```

3. **Start the Reveal.js Server**:
   ```bash
   cd reveal.js && npm start
   ```

   This will automatically clone the Reveal.js repository, install dependencies, and start the presentation server.

## 🖼️ Assets
- Place your images in the `./images` directory.

## 🔧 Customization
- Modify `flake.nix` to add or remove packages as needed.
- Edit your presentation files directly in the `reveal.js` folder.

## 📄 License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

