import {test, expect} from "@playwright/test";
import {TimelogHelper} from "./timelogHelpers";
import {DateTime} from "luxon";

test.describe.configure({mode: 'parallel'});

test("You can create a Timelog entry using the Timer button", async ({ page }) => {
    test.setTimeout(100_000);

    await TimelogHelper.login(page, "admin", "admin");

    await TimelogHelper.createTimelogFromTimer(page, "Test Task", "Timer Timelog!");

    // merely clicking the Time Log link does not display the new timelog, page must be reloaded
    await page.getByRole("link", {name: "Time Log"}).click();
    await page.reload();

    await expect(page.getByText("Timer Timelog!")).toBeVisible();
});

test("You can create a Timelog entry by navigating to Timelog->Add Timelog", async ({ page }) => {
    test.setTimeout(100_000);

    await TimelogHelper.login(page, 'admin', 'admin');

    await TimelogHelper.createTimelog(
        page,
        "Test Task", "2",
        DateTime.fromFormat("1/1/2021", "d/M/y").setLocale("en-AU"),
        "9:00", "10:00",
        "Manual Timelog!"
    );
    await page.getByRole("link", {name: "Test Task"}).click();
    await page.getByRole("link", {name: "Time Log"}).click();

    await expect(page.getByText("Manual Timelog!")).toBeVisible();
});