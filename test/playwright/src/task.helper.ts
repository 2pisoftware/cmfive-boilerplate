import { CmfiveHelper } from "./helpers";
import { Page } from "@playwright/test";
import { DateTime } from "luxon";

export class TaskHelper  {
    constructor(parameters)
    {

    }

    static async createTaskGroup(
        page: Page,
        groupTitle: string,
        groupType: "To Do" | "Software Development" | "Cmfive Support",
        whoCanAssign:         "GUEST" | "MEMBER" | "OWNER",
        whoCanView:   "ALL" | "GUEST" | "MEMBER" | "OWNER",
        whoCanCreate: "ALL" | "GUEST" | "MEMBER" | "OWNER",
        automaticSubscription: boolean = true)
    {
        CmfiveHelper.clickCmfiveNavbar(page, "Task", "Task Groups");
        await page.getByRole("link", {name: "New Task Group"}).click();

        await page.getByLabel("Title").fill(groupTitle);
        await page.getByRole("combobox", {name: "Who Can Assign"}).selectOption(whoCanAssign);
        await page.getByRole("combobox", {name: "Who Can View"}).selectOption(whoCanView);
        await page.getByRole("combobox", {name: "Who Can Create"}).selectOption(whoCanCreate);

        await page.getByRole('combobox', {name: "Task Group Type"}).selectOption(groupType);
        switch (groupType) {
        case "To Do":
            await page.getByRole("combobox", {name: "Default Task Type"}).selectOption("To Do");
            break;
        case "Software Development":
            await page.getByRole("combobox", {name: "Default Task Type"}).selectOption("Programming Task");
            break;
        case "Cmfive Support":
            await page.getByRole("combobox", {name: "Default Task Type"}).selectOption("Support Ticket");
            break;
        }
    }
}