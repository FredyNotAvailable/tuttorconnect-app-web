// src/themes/theme.js
import { extendTheme } from "@chakra-ui/react";

const colors = {
  primary: "#910048",        // Flutter primary
  secondary: "#FFC107",      // Flutter secondary
  background: "#F5F5F5",     // Flutter background
  surface: "#FFFFFF",        // Flutter surface
  error: "#D32F2F",          // Flutter error
  onPrimary: "#FFFFFF",      // Flutter onPrimary
  onSecondary: "#000000",    // Flutter onSecondary
};

const theme = extendTheme({
  colors: {
    brand: {
      50: "#fce4ec",
      100: "#f8bbd0",
      200: "#f48fb1",
      300: "#f06292",
      400: "#ec407a",
      500: colors.primary, // main
      600: "#880036",
      700: "#6f0030",
      800: "#550029",
      900: "#3b001c",
    },
    secondary: {
      500: colors.secondary,
    },
    error: {
      500: colors.error,
    },
    background: {
      DEFAULT: colors.background,
    },
    surface: {
      DEFAULT: colors.surface,
    },
  },
  styles: {
    global: {
      body: {
        bg: colors.background,
        color: colors.onSecondary,
      },
    },
  },
  semanticTokens: {
    colors: {
      "chakra-body-bg": colors.background,
      "chakra-body-text": colors.onSecondary,
      "chakra-border-color": colors.surface,
    },
  },
});

export default theme;
