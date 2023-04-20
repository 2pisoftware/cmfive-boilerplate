import { HOST, CmfiveHelper } from "./cmfive.helper";
import { expect, Page } from "@playwright/test";

export class TaskHelper  {
    /**
     * returns the taskgroup id
     */
    static async createTaskGroup(
        page: Page,
        groupName: string,
        groupType: "To Do" | "Software Development" | "Cmfive Support",
        whoCanAssign:         "GUEST" | "MEMBER" | "OWNER",
        whoCanView:   "ALL" | "GUEST" | "MEMBER" | "OWNER",
        whoCanCreate: "ALL" | "GUEST" | "MEMBER" | "OWNER",
        automaticSubscription: boolean = true
    ): Promise<string> {
        if(page.url() != HOST + "/task-group/viewtaskgrouptypes#dashboard")
            CmfiveHelper.clickCmfiveNavbar(page, "Task", "Task Groups");

        await page.getByRole("link", {name: "New Task Group"}).click();

        await page.getByLabel("Title").fill(groupName);

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

        await page.getByRole("combobox", {name: "Who Can Assign"}).selectOption(whoCanAssign);
        await page.getByRole("combobox", {name: "Who Can View"}).selectOption(whoCanView);
        await page.getByRole("combobox", {name: "Who Can Create"}).selectOption(whoCanCreate);
        await page.getByRole("combobox", {name: "Default Priority"}).selectOption("Normal");

        const subcheckbox = await page.getByRole("checkbox", {name: "Automatic Subscription"});
        if (automaticSubscription)
            await subcheckbox.check();
        else
            subcheckbox.uncheck();

        await page.getByRole("button", {name: "Save"}).click();

        await expect(page.getByText("Task Group " + groupName + " added")).toBeVisible();

        return page.url().split("/viewmembergroup/")[1].split("#")[0];
    }

    static async deleteTaskGroup(page: Page, groupName: string, groupID: string)
    {
        if(page.url() != HOST + "/task-group/viewmembergroup/" + groupID + "#members") {
            if(page.url() != HOST + "/task-group/viewtaskgrouptypes#dashboard")
                CmfiveHelper.clickCmfiveNavbar(page, "Task", "Task Groups");
            
            await page.getByRole("link", {name: groupName, exact: true}).click();
        }

        await page.getByRole("button", {name: "Delete Task Group"}).click();
        await page.click('#cmfive-modal button:text-is("Delete")');

        await expect(page.getByText("Task Group " + groupName + " deleted.")).toBeVisible();
    }

    static async addMemberToTaskgroup(page: Page, groupName: string, groupID: string, memberName: string, role: "ALL" | "GUEST" | "MEMBER" | "OWNER")
    {
        if(page.url() != HOST + "/task-group/viewmembergroup/" + groupID + "#members") {
            if(page.url() != HOST + "/task-group/viewtaskgrouptypes#dashboard")
                CmfiveHelper.clickCmfiveNavbar(page, "Task", "Task Groups");
            
            await page.getByRole("link", {name: groupName, exact: true}).click();
        }

        await page.getByRole("button", {name: "Add New Members"}).click();

        await page.getByRole("combobox", {name: "As Role"}).selectOption(role);
        await page.getByRole("combobox", {name: "Add Group Members"}).selectOption(memberName);
        await page.getByRole("button", {name: "Submit"}).click();

        await expect(page.getByText("Task Group updated")).toBeVisible();
    }

    static async setDefaultAssignee(page: Page, groupName: string, groupID: string, assignee: string)
    {
        if(page.url() != HOST + "/task-group/viewmembergroup/" + groupID + "#members") {
            if(page.url() != HOST + "/task-group/viewtaskgrouptypes#dashboard")
                CmfiveHelper.clickCmfiveNavbar(page, "Task", "Task Groups");
            
            await page.getByRole("link", {name: groupName, exact: true}).click();
        }
        
        await page.getByRole("button", {name: "Edit Task Group"}).click();

        await page.getByRole("combobox", {name: "Default Assignee"}).selectOption(assignee);

        await page.getByRole("button", {name: "Update"}).click();

        await expect(page.getByText("Task Group " + groupName + " updated.")).toBeVisible();
    }

    /**
     * returns the task id
     */
    static async createTask(page: Page, taskName: string, groupName: string, groupType: "To Do" | "Software Development" | "Cmfive Support", assignee?: string): Promise<string>
    {
        await CmfiveHelper.clickCmfiveNavbar(page, "Task", "New Task");

        await CmfiveHelper.fillAutoComplete(page, "task_group_id", groupName, groupName);
        await page.getByLabel('Task Title Required').fill(taskName);
        
        if (assignee) await page.getByRole("combobox", {name: "Assigned To"}).selectOption(assignee);

        switch (groupType) {
        case "To Do":
            await page.getByRole("combobox", {name: "Task Type Required"}).selectOption("To Do");
            break;
        case "Software Development":
            await page.getByRole("combobox", {name: "Task Type Required"}).selectOption("Programming Task");
            break;
        case "Cmfive Support":
            await page.getByRole("combobox", {name: "Task Type Required"}).selectOption("Support Ticket");
            break;
        }

        await page.getByRole("button", {name: "Save"}).click();

        await page.waitForURL(HOST + "/task/edit/*"); // will hang if task creation failed? poor man's expect(...)?

        return page.url().split("/edit/")[1].split("#")[0];
    }

    static async deleteTask(page: Page, taskName: string, taskID: string)
    {
        if(page.url() != HOST + "/task/edit/" + taskID + "#details") {
            if(page.url() != HOST + "/task/tasklist")
                await CmfiveHelper.clickCmfiveNavbar(page, "Task", "Task List");
            
            await page.getByRole("link", {name: taskName, exact: true}).click();
        }

        await page.getByRole("button", {name: "Delete"}).first().click();

        await expect(page.getByRole("link", {name: taskName, exact: true})).not.toBeVisible();
    }
}