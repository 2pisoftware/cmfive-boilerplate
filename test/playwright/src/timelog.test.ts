import {test, expect} from "@playwright/test";
import {TimelogHelper} from "./timelog.helper";
import {CmfiveHelper} from "./helpers";
import {DateTime} from "luxon";

test.describe.configure({mode: 'parallel'});

test("You can create a Timelog entry using the Timer button", async ({ page }) => {
    test.setTimeout(100_000);
    const timelogID = CmfiveHelper.randomID("timelog_id_");

    await CmfiveHelper.login(page, "admin", "admin");

    await TimelogHelper.createTimelogFromTimer(page, "Test Task", timelogID);
    await TimelogHelper.editTimelog(page, "Test Task", timelogID, DateTime.fromFormat("1/1/2021", "d/M/y").setLocale("en-AU"), "19:00", "20:30");
    await TimelogHelper.deleteTimelog(page, "Test Task", timelogID);
});

// test("You can create a Timelog entry by navigating to Timelog->Add Timelog", async ({ page }) => {
//     test.setTimeout(100_000);

//     await CmfiveUIHelper.login(page, 'admin', 'admin');

//     await TimelogHelper.createTimelog(
//         page,
//         "Test Task", "2",
//         DateTime.fromFormat("1/1/2021", "d/M/y").setLocale("en-AU"),
//         "9:00", "10:00",
//         "Manual Timelog!"
//     );
//     await page.getByRole("link", {name: "Test Task"}).click();
//     await page.getByRole("link", {name: "Time Log"}).click();

//     await expect(page.getByText("Manual Timelog!")).toBeVisible();
// });