import { Page, expect } from "@playwright/test";
import { DateTime } from "luxon";

const HOST = "http://localhost:3500";

export class CmfiveHelper {
    constructor(parameters)
    {

    }

    static randomID = (prefix: string) => prefix + (Math.random() + 1).toString(36).substring(7)

    static getRowByText(page: Page, text: string)
    {
        return page.locator('tr:has-text("' + text + '")');
    }

    static async login(page: Page, user: string, password: string)
    {
        await page.goto(HOST + "/auth/login");
        await page.locator("#login").fill(user);
        await page.locator("#password").fill(password);
        await page.getByRole("button", {name: "Login"}).click();
    }

    static async logout(page: Page)
    {
        await page.goto(HOST + "/auth/logout");
    }

    static async isBootstrap5(page: Page): Promise<boolean>
    {
        return await page.locator("html.theme").count() == 1;
    }

    static async clickCmfiveNavbar(page: Page, category: string, option: string)
    {
        const navbarCategory = page.locator("#topnav_" + category.toLowerCase().split(" ").join("_"));
        
        const bootstrap5 = await this.isBootstrap5(page);
        if(bootstrap5)
            await navbarCategory.click();
        else /* Foundation */
            await navbarCategory.hover();

        await page.getByText(option).click();
    }

    static async waitForBackendToRefresh(page: Page, timeout: number = 14_000)
    {
        await page.locator(".loading_overlay").waitFor({state: "hidden", timeout: 14_000});
    }

    static async skipConfirmation(page: Page)
    {
        page.on('dialog', dialog => dialog.accept());
    }

    static async fillDatePicker(page: Page, datePickerTitle: string, field: string, date: DateTime) {          
        await page.getByText(datePickerTitle).click();
        await page.keyboard.type(date.toFormat("ddLLyyyy"));

        const expectedDate = date.toISODate();
        if(expectedDate == null) // needed to collapse into string from string|null
            throw new Error("date.toISODate() returned null");
        else
            await expect(page.locator("#" + field)).toHaveValue(expectedDate);
    }   
}

    /*

    // NEEDS WORK
    static async fillDateTimePicker(page: Page, field: string, date: DateTime) {
        const dateFormatted = date.toFormat('D HH:mm');
        const finalDateFormatted = date.toFormat('D hh:mm a').toLowerCase(); // i.e 26/11/2004 01:07 pm
        await page.evaluate('$("#' + field + '").datepicker("setDate","' + dateFormatted + '");');
        await expect(page.locator('#' + field)).toHaveValue(finalDateFormatted);
    }

    // NEEDS WORK
    static async fillTimePicker(page: Page, field: string, date: DateTime) {
        const dateFormatted = date.toFormat('D HH:mm');
        const finalTimeFormatted = date.toFormat('hh:mm a').toLowerCase(); // i.e 01:07 pm
        await page.evaluate('$("#' + field + '").datepicker("setDate","' + dateFormatted + '");');
        await expect(page.locator('#' + field)).toHaveValue(finalTimeFormatted);
    }

    // THIS SUCKS, NEEDS WORK
    static async fillAutoComplete(page: Page, field: string, value: string) {
        await page.locator('#acp_' + field).click();
        await page.keyboard.type(value.split(' - ')[1]);
        await page.getByText(value).click();
    }

    // static async fillForm(page: Page, data: WhatIsThis) what is data? array of ... keyvalue pairs? keyvalue pairs are strings like "name:value"?
    */
