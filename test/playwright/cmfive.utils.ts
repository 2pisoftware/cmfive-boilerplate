import { Page, expect } from "@playwright/test";
import { DateTime } from "luxon";

export const HOST = (process.env.TEST_HOST ?? "http://127.0.0.1") + ":" + (process.env.TEST_PORT ?? "3000");
export const GLOBAL_TIMEOUT = +(process.env.TIMEOUT ?? 30_000);

export class CmfiveHelper {
    static randomID = (prefix: string) => prefix + (Math.random() + 1).toString(36).substring(7)

    static async login(page: Page, user: string, password: string)
    {
        await page.goto(HOST + "/auth/login");
        await page.locator("#login").fill(user);
        await page.locator("#password").fill(password);
        await page.getByRole("button", {name: "Login"}).click();
        await page.waitForURL(HOST + "/main/index")   
    }

    static async logout(page: Page)
    {
        await page.goto(HOST + "/auth/logout");
    }

    static async isBootstrap5(page: Page)
    {
        await page.waitForSelector('#cmfive-body, body > .row-fluid');
    
        return await page.locator('html.theme').count() > 0
    }

    static getRowByText(page: Page, text: string)
    {
        return page.locator("tr", { has: page.getByText(text, {exact: true}) });
    }

    static async clickCmfiveNavbar(page: Page, isMobile: boolean, category: string, option: string)
    {
        const bootstrap5 = await this.isBootstrap5(page);

        if (isMobile)
            if (bootstrap5)
                await page.locator(".bi-list").first().click();
            else
                await page.getByRole("link", {name: "Menu"}).click();

        const navbarCategory = isMobile && bootstrap5
            ? page.locator("#accordion_menu_" + category.toLowerCase().split(" ").join("_") + "_heading")
            : page.locator("#topnav_" + category.toLowerCase().split(" ").join("_"));

        if (bootstrap5 || isMobile) {
            await navbarCategory.click();
            // check that nav menu is open
            const menuOpen = await page.locator("#topnav_" + category.toLowerCase().split(" ").join("_") + "_dropdown_link").getAttribute("aria-expanded"); // toHaveAttribute("aria-expanded", "true")
            if (bootstrap5 && menuOpen != "true") {
                await navbarCategory.click();
            }

        } else { // Foundation
            await navbarCategory.hover();
        }

        if (bootstrap5 && isMobile)
            await page.locator("#accordion_menu_" + category.toLowerCase().split(" ").join("_"))
                .getByRole('link', {name: option, exact: true}).click();
        else
            await navbarCategory.getByRole('link', {name: option, exact: true}).click();
    }

    // Call exactly once per test before any dialogs pop up
    static acceptDialog(page: Page)
    {
        page.on('dialog', dialog => void dialog.accept());
    }

    static async fillDatePicker(page: Page, datePickerTitle: string, field: string, date: DateTime) {          
        await page.getByText(datePickerTitle).click();
        await page.keyboard.type(date.toFormat("ddLLyyyy"));

        const expectedDate = date.toISODate();
        if(expectedDate == null)
            throw new Error("date.toISODate() returned null");
        else
            await expect(page.locator("#" + field)).toHaveValue(expectedDate);
    }   

    static async fillAutoComplete(page: Page, field: string, search: string, value: string) {
		if (await this.isBootstrap5(page)) {
			await page.locator(`#${field}-ts-control`).locator("..").click();
			await page.keyboard.type(search);
			await page.locator(`#${field}-ts-dropdown`).getByText(value).click();
			// await page.keyboard.press("Escape");
		}
		else {
			await page.locator('#acp_' + field).click();
			await page.keyboard.type(search);
			await page.locator('.ui-menu-item :text("' + value + '")').click();
		}
    }

    // Finds substring in string with given position
    static findString(target: string, searchText: string, searchPosition?: 'start' | 'end'): boolean {
        if (searchPosition === 'start') {
            return target.startsWith(searchText);
        } else if (searchPosition === 'end') {
            return target.endsWith(searchText);
        } else {
            return target.includes(searchText);
        }
        }
    
    // Finds a cell in a table by an item in its row and the column header
    static async getColumnByText(page: Page, rowText: string, columnText: string,  searchPosition?: 'start' | 'end'){
        const headers = page.locator('table thead tr th');
        let columnIndex: number | undefined;

        // iterate through the columns until a header contains, begins or starts with columnText
        for (let i = 0; i < (await headers.count()); i++) {
            const headerText = await headers.nth(i).textContent();
            if (CmfiveHelper.findString(headerText?.trim(),columnText, searchPosition)) {
            columnIndex = i; // index for nth-child selector
            break;
            }
        }
        const row = CmfiveHelper.getRowByText(page, rowText); 
        return row.getByRole("cell").nth(columnIndex);
    }
    

}
