import { CmfiveHelper } from "./helpers";
import { Page } from "@playwright/test";
import { DateTime } from "luxon";

export class TimelogHelper  {
    constructor(parameters)
    {

    }

    /**
     * Creates a Timelog entry from the Timer.
     * 
     * @param page Page
     * @param taskName string
     * @param start_time string?
     */
    static async createTimelogFromTimer(page: Page, taskName: string, description: string = "", start_time: string = "")
    {
        await CmfiveHelper.clickCmfiveNavbar(page, "Task", "Task List");
        await page.getByRole("link", {name: taskName}).click();
        await page.locator("#start_timer").click();

        await page.waitForSelector("#start_time", {state: "visible"});
        await page.waitForSelector("#timerModal", {state: "visible"});
        await page.locator("#start_time").fill(start_time);
        await page.getByLabel("Enter Description").fill(description);

        // why doesn't this work here: page.getByRole("button", { name: "Save" }).click();         
        await page.click('#timerModal button:text-is("Save")');

        await page.waitForSelector("#stop_timer", {state: "visible"});
        await page.locator("#active_log_time").click();
    }

    /**
     * Creates a Timelog entry with Timelog->Add Timelog.
     * 
     * @param page Page 
     * @param taskName string 
     * @param taskID string
     * @param date DateTime
     * @param start_time string
     * @param end_time string
     */
    static async createTimelog(page: Page, taskName: string, taskID: string, date: DateTime, start_time: string, end_time: string, description: string = "")
    {
        await CmfiveHelper.clickCmfiveNavbar(page, "Timelog", "Add Timelog");
        await page.waitForSelector("#cmfive-modal", {state: "visible"});
    
        await page.locator("#acp_search").click();
        await page.keyboard.type(taskName); // autocomplete requires typing
        await page.getByText(taskID + " - " + taskName).click();
        
        await page.getByLabel("Description").fill(description);
        await CmfiveHelper.fillDatePicker(page, "Date Required", "date_start", date);
        await page.locator("#time_start").fill(start_time);
        await page.locator("#time_end").fill(end_time);
        await page.getByRole("button", {name: "Save"}).click();
    }

    /**
     * Edits Timelog entry using the edit action.
     * Expects only one Timelog entry for the Task.
     * 
     * @param page Page
     * @param taskName string
     * @param date DateTime
     * @param start_time string
     * @param end_time string
     */
    static async editTimelog(page: Page, taskName: string, date: DateTime, start_time: string, end_time: string)
    {
        await CmfiveHelper.clickCmfiveNavbar(page, "Timelog", "Timelog Dashboard");
        await page.getByRole("link", {name: "Time Log", exact: true}).click();
        await page.getByRole("link", {name: "Edit", exact: true}).click();
        
        await CmfiveHelper.fillDatePicker(page, "Date", "date_start", date);
        await page.locator("#time_start").fill(start_time);
        await page.locator("#time_end").fill(end_time);
        await page.getByRole("button", {name: "Save"}).click();
    }

    /**
     * Deletes Timelog entry using the delete action.
     * Expects only one Timelog entry for the Task.
     * 
     * @param page Page
     * @param task string
     */
    static async deleteTimelog(page: Page, taskName: string)
    {
        await CmfiveHelper.clickCmfiveNavbar(page, "Timelog", "Timelog Dashboard");
        await page.getByRole("link", {name: taskName}).click();
        await page.getByRole("link", {name: "Time Log", exact: true}).click();

        await CmfiveHelper.skipConfirmation(page);
        await page.getByText("Delete").click();
    }
}