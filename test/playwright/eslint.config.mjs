import globals from "globals";
import pluginJs from "@eslint/js";
import tseslint from "typescript-eslint";
import noFloatingPromise from "eslint-plugin-no-floating-promise";
import playwright from 'eslint-plugin-playwright'

/** @type {import('eslint').Linter.Config[]} */
export default [
    { files: ["**/*.{js,mjs,cjs,ts}"] },
    { languageOptions: { globals: globals.node } },
    pluginJs.configs.recommended,
    ...tseslint.configs.recommendedTypeChecked,

    {
        ...playwright.configs['flat/recommended'],
        rules: {
            ...playwright.configs['flat/recommended'].rules,
            "playwright/no-conditional-in-test": "off",
        },
    },

    {
        languageOptions: {
            parserOptions: {
                projectService: true,
                tsconfigRootDir: import.meta.dirname,
            },
        },

        plugins: {
            "no-floating-promise": noFloatingPromise,
        },
    }
];