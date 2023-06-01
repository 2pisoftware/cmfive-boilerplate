import { expect, Page } from "@playwright/test";
import { HOST, CmfiveHelper } from "./cmfive.helper";

export class AdminHelper {
    static async createUser(page: Page, username: string, password: string, firstname: string, lastname: string, email: string, permissions: string[] = [])
    {
        await page.waitForTimeout(100); // let page load so next line doesn't fail if previous function ended on a redirect to user list
        if(page.url() != HOST + "/admin/users#internal")
            await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Users");
        await page.waitForURL(HOST + "/admin/users#internal");

        await page.getByRole("button", {name: "Add New User"}).click();

        await page.waitForSelector("#cmfive-modal", {state: "visible"});

        await page.getByLabel("Active", {exact: true}).check();
        await page.getByLabel("Login Required").fill(username);
        await page.getByLabel("Password", {exact: true}).fill(password);
        await page.getByLabel("Repeat Password").fill(password);
        await page.getByLabel("First Name").fill(firstname);
        await page.getByLabel("Last Name").fill(lastname);
        await page.getByLabel("Email").fill(email);


        if(permissions.length == 0)
            permissions.push("user");
        
        for(let permission of permissions)
            await page.getByText(permission, {exact: true}).check();

        await page.getByRole("button", {name: "Save"}).click();

        await expect(page.getByText("User " + username + " added")).toBeVisible();
    }

    static async deleteUser(page: Page, username: string)
    {
        await page.waitForTimeout(100); // let page load so next line doesn't fail if previous function ended on a redirect to user list
        if(page.url() != HOST + "/admin/users#internal")
            await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Users");
        await page.waitForURL(HOST + "/admin/users#internal");


        await CmfiveHelper.getRowByText(page, username).getByRole("button", {name: "Remove"}).click();
        await page.getByRole("button", {name: "Delete user", exact: true}).click();
    
        await expect(page.getByText("User " + username + " deleted.")).toBeVisible();
    }

    static async editUser(page: Page, username: string, data: [string, string][])
    {
        await page.waitForTimeout(100); // let page load so next line doesn't fail if previous function ended on a redirect to user list
        if(page.url() != HOST + "/admin/users#internal")
            await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Users");
        await page.waitForURL(HOST + "/admin/users#internal");

        await CmfiveHelper.getRowByText(page, username).getByRole("button", {name: "Edit"}).click();

        for(let [label, value] of data)
            await page.getByLabel(label, {exact: true}).fill(value);

        await page.getByRole("button", {name: "Update"}).click();

        await page.waitForEvent("requestfinished");
        await expect(page.getByText("Account details updated").nth(3)).toBeVisible();
    }

    static async createLookupType(page: Page, type: string, code: string, lookup: string)
    {
        if(page.url() != HOST + "/admin/lookup#tab-1")
            await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Lookup");

        await page.getByRole("link", {name: "New Item", exact: true}).click();

        await page.getByLabel("or Add New Type").fill(type);
        await page.getByLabel("Code").fill(code);
        await page.getByLabel("Title").fill(lookup);
        await page.getByRole("button", {name: "Save"}).click();

        await expect(page.getByText("Lookup Item added")).toBeVisible();
    }

    static async createLookup(page: Page, type: string, code: string, lookup: string)
    {
        if(page.url() != HOST + "/admin/lookup#tab-1")
            await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Lookup");
            
        await page.getByRole("link", {name: "New Item", exact: true}).click();

        await page.getByRole('combobox', { name: 'Type' }).selectOption(type);
        await page.getByLabel("Code").fill(code);
        await page.getByLabel("Title", {exact: true}).fill(lookup);
        await page.getByRole("button", {name: "Save"}).click();

        await expect(page.getByText("Lookup Item added")).toBeVisible();
    }

    static async deleteLookup(page: Page, lookup: string)
    {
        if(page.url() != HOST + "/admin/lookup#tab-1")
            await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Lookup");

        await CmfiveHelper.getRowByText(page, lookup).getByRole("button", {name: "Delete"}).click();
    }

    static async editLookup(page: Page, lookup: string, data: Record<string, string>)
    {
        if(page.url() != HOST + "/admin/lookup#tab-1")
            await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Lookup");
        
        await CmfiveHelper.getRowByText(page, lookup).getByRole("button", {name: "Edit"}).click();
        await page.waitForSelector("#cmfive-modal", {state: "visible"});

        if(data["Type"] != undefined)
            await page.getByLabel("Type", {exact: true}).selectOption(data["Type"]);

        if(data["Code"] != undefined)
            await page.getByLabel("Key", {exact: true}).fill(data["Code"]);
        
        if(data["Title"] != undefined)
            await page.getByLabel("Value", {exact: true}).fill(data["Title"]);

        await page.getByRole("button", {name: "Update"}).click();

        await expect(page.getByText("Lookup Item edited")).toBeVisible();
    }

    /**
     * returns the usergroup ID 
     */
    static async createUserGroup(page: Page, usergroup: string): Promise<string>
    {
        if(page.url() != HOST + "/admin/groups")
            await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Groups");
        
        await page.getByRole("button", {name: "New Group"}).click();
        await page.waitForSelector("#cmfive-modal", {state: "visible"});

        await page.getByLabel("Group Title: Required").fill(usergroup);
        await page.getByRole("button", {name: "Save"}).click();

        await expect(page.getByText("New group added!")).toBeVisible();

        await CmfiveHelper.getRowByText(page, usergroup).getByRole("button", {name: "More Info"});
        return page.url().split("/moreInfo/")[1];
    }

    static async deleteUserGroup(page: Page, usergroup: string)
    {
        if(page.url() != HOST + "/admin/groups")
            await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Groups");

        await CmfiveHelper.getRowByText(page, usergroup).getByRole("button", {name: "Delete"}).click();

        await expect(page.getByText("Group is deleted!")).toBeVisible();
    }

    static async addUserGroupMember(page: Page, usergroup: string, usergroupID: string, user: string, owner: boolean = false)
    {
        if(page.url() != HOST + "/admin/moreInfo" + usergroupID) {
            if(page.url() != HOST + "/admin/groups")
                await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Groups");
            
            await CmfiveHelper.getRowByText(page, usergroup).getByRole("button", {name: "More Info"}).click();   
        }

        await page.getByRole("button", {name: "New Member"}).click();
        await page.waitForSelector("#cmfive-modal", {state: "visible"});

        await page.getByLabel("Select Member: Required").selectOption(user);

        if(owner)
            await page.getByLabel("Owner").check();
        else
            await page.getByLabel("Owner").uncheck();

        await page.getByRole("button", {name: "Save"}).click();

        await expect(page.getByText(user).first()).toBeVisible();
    }

    static async deleteUserGroupMember(page: Page, usergroup: string, usergroupID: string, user: string)
    {
        if(page.url() != HOST + "/admin/moreInfo" + usergroupID) {
            if(page.url() != HOST + "/admin/groups")
                await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Groups");
            
            await CmfiveHelper.getRowByText(page, usergroup).getByRole("button", {name: "More Info"}).click();   
        }

        await CmfiveHelper.getRowByText(page, user).getByRole("link", {name: "Delete"}).click();

        await expect(page.getByText("Member is deleted!")).toBeVisible();
    }

    static async editUserGroupPermissions(page: Page, usergroup: string, usergroupID: string, permissions: string[])
    {
        if(page.url() != HOST + "/admin/moreInfo" + usergroupID) {
            if(page.url() != HOST + "/admin/groups")
                await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Groups");
            
            await CmfiveHelper.getRowByText(page, usergroup).getByRole("button", {name: "More Info"}).click();   
        }

        await page.getByRole("button", {name: "Edit Permissions"}).click();

        for(let permission of permissions)
            await page.getByText(permission, {exact: true}).check();

        await page.getByRole("button", {name: "Save"}).click();

        await expect(page.getByText("Permissions are updated!")).toBeVisible();
    }

    /**
     * returns the template ID
     */
    static async createTemplate(page: Page, templateTitle: string, module: string, category: string, code: string[]): Promise<string>
    {
        await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Templates");
        await page.getByRole("button", {name: "Add Template"}).click();

        await page.getByLabel("Active").check();
        await page.getByLabel("Title").fill(templateTitle);
        await page.getByLabel("Module").fill(module);
        await page.getByLabel("Category").fill(category);
        await page.getByRole("button", {name: "Save"}).click();
        await expect(page.getByText("Template saved")).toBeVisible();

        await page.getByRole("link", {name: "Template", exact: true}).click();
        await page.locator("#template_title").fill(templateTitle);
        
        await page.locator(".CodeMirror-lines").click();

        // code mirror auto completes open/closed html tags, so skip writing them
        // typing <table> puts cursor on new line between <table> and </table>
        // typing <tr>/<td> writes </tr>/</td> respectively on the same line, cursor before the closing tag

        for(let line of code) {
            if(line.indexOf("</") != -1) {    
                await page.keyboard.type(line.split("</")[0]);

                for(let i = 0; i < line.split("</")[1].length + 2; i++)
                    await page.keyboard.press("ArrowRight");

                await page.keyboard.press("Enter");
                continue;
            }

            await page.keyboard.type(line);
            await page.keyboard.press("Enter");
        }
        
        await page.getByRole("button", {name: "Save"}).click();
        await expect(page.getByText("Template saved")).toBeVisible();

        return page.url().split("/admin-templates/edit/")[1].split("#")[0];
    }

    static async demoTemplate(page: Page, templateTitle: string, templateID: string): Promise<Page>
    {
        if(page.url() != HOST + "/admin-templates/edit/" + templateID + "#details") {
            if(page.url() != HOST + "/admin-templates")
                await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Templates");
            
            await CmfiveHelper.getRowByText(page, templateTitle).getByRole("button", {name: "Edit"}).click();
        }

        await page.getByRole("link", {name: "Test Output"}).click();

        const [pages] = await Promise.all([page.context().waitForEvent("page")]);
        const tabs = pages.context().pages();
        console.log(tabs.length);
        await tabs[1].waitForLoadState("load");

        return tabs[1];
    }
}