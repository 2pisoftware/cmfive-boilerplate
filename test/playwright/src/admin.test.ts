import { expect, test } from "@playwright/test";
import { GLOBAL_TIMEOUT, CmfiveHelper } from "./cmfive.helper";
import { AdminHelper} from "./admin.helper";

test.describe.configure({mode: 'parallel'});

test("Test that an admin can create and delete a user", async ({ page }) => {
    test.setTimeout(GLOBAL_TIMEOUT);
    CmfiveHelper.acceptDialog(page);

    await CmfiveHelper.login(page, "admin", "admin");
    
    const user = CmfiveHelper.randomID("user_");
    await AdminHelper.createUser(
        page,
        user,
        user+"_password",
        user+"_firstName",
        user+"_lastName",
        user+"@localhost.com"
    );

    await AdminHelper.deleteUser(page, user);
});

test("Test that users, groups & permissions are assignable", async ({ page }) => {
    test.setTimeout(GLOBAL_TIMEOUT);
    CmfiveHelper.acceptDialog(page);

    await CmfiveHelper.login(page, "admin", "admin");
    
    const user = CmfiveHelper.randomID("user_");
    await AdminHelper.createUser(
        page,
        user,
        user+"_password",
        user+"_firstName",
        user+"_lastName",
        user+"@localhost.com"
    );

    const parentgroup = CmfiveHelper.randomID("usergroup_");
    const usergroup = CmfiveHelper.randomID("usergroup_");
    const parentgroupID = await AdminHelper.createUserGroup(page, parentgroup);
    const usergroupID = await AdminHelper.createUserGroup(page, usergroup);
    await AdminHelper.addUserGroupMember(page, parentgroup, parentgroupID, usergroup.toUpperCase());
    await AdminHelper.addUserGroupMember(page, usergroup, usergroupID, user+"_firstName " + user+"_lastName");
    
    await AdminHelper.editUserGroupPermissions(page, usergroup, usergroupID, ["user", "comment"]);
    await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Users");
    await CmfiveHelper.getRowByText(page, user).getByRole("button", {name: "Permissions"}).click();
    await expect(page.getByRole("checkbox", {name: "comment"})).toBeChecked();
    await expect(page.getByRole("checkbox", {name: "comment"})).toBeDisabled();

    await AdminHelper.deleteUserGroup(page, usergroup);
    await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Users");
    await CmfiveHelper.getRowByText(page, user).getByRole("button", {name: "Permissions"}).click();
    await expect(page.getByRole("checkbox", {name: "comment"})).not.toBeChecked();
    await expect(page.getByRole("checkbox", {name: "comment"})).not.toBeDisabled();

    await AdminHelper.deleteUserGroup(page, parentgroup);
    await AdminHelper.deleteUser(page, user);
});

test("Test that Cmfive Admin handles lookups", async ({ page }) => {
    test.setTimeout(GLOBAL_TIMEOUT);
    CmfiveHelper.acceptDialog(page);

    await CmfiveHelper.login(page, "admin", "admin");
    
    const user = CmfiveHelper.randomID("user_");
    await AdminHelper.createUser(
        page,
        user,
        user+"_password",
        user+"_firstName",
        user+"_lastName",
        user+"@localhost.com"
    );

    const lookup_1 = user + "_lookup_1";
    const lookup_2 = user + "_lookup_2";
    const lookup_3 = user + "_lookup_3";

    await AdminHelper.editUser(page, user, [["Title", lookup_1]]);
    await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Lookup");
    await expect(page.getByText(lookup_1).first()).toBeVisible();

    await AdminHelper.editLookup(page, lookup_1, {"Title": lookup_2});
    await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Users");
    await CmfiveHelper.getRowByText(page, user).getByRole("button", {name: "Edit"}).click();
    await page.getByText("Title").click();
    await page.waitForTimeout(500);
    await expect((await page.content()).includes(lookup_2)).toBeTruthy();
    
    await AdminHelper.deleteLookup(page, lookup_2);
    await expect(page.getByText("Cannot delete lookup as it is used as a title for the contacts: " + user+"_firstName " + user+"_lastName")).toBeVisible();

    await AdminHelper.createLookup(page, "title", lookup_3, lookup_3);
    await expect(page.getByText(lookup_3).first()).toBeVisible();

    await AdminHelper.editUser(page, user, [["Title", lookup_3]]);
    await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Lookup");
    await AdminHelper.deleteLookup(page, lookup_2);
    await expect(page.getByText("Lookup Item deleted")).toBeVisible();

    await AdminHelper.deleteUser(page, user);
    
    await AdminHelper.deleteLookup(page, lookup_1);
    await expect(page.getByText("Lookup Item deleted")).toBeVisible();

    await AdminHelper.deleteLookup(page, lookup_2);
    await expect(page.getByText("Lookup Item deleted")).toBeVisible();

    await AdminHelper.deleteLookup(page, lookup_3);
    await expect(page.getByText("Lookup Item deleted")).toBeVisible();
});

test("Test that Cmfive Admin handles templates", async ({ page }) => {
    test.setTimeout(GLOBAL_TIMEOUT);

    await CmfiveHelper.login(page, "admin", "admin");
    
    const template = CmfiveHelper.randomID("template_");
    const templateID = await AdminHelper.createTemplate(page, template, "Admin", "Templates", [
         "<table width='100%' align='center' class='form-table' cellpadding='1'>"
        ,"    <tr>"
        ,"        <td colspan='2' style='border:none;'>"
        ,"            <img width='400' src='' style='width: 400px;' />"
        ,"        </td>"
        ,"        <td colspan='2' style='border:none; text-align:right;'>"
        ,"            Test Company<br/>"
        ,"            123 Test St, Test Town, NSW 1234<br/>"
        ,"            test@example.com<br/>"
        ,"            ACN: 123456789<br/>"
        ,"            ABN: 12345678901<br/>"
        ,"        </td>"
        ,"    </tr>"
        ,"</table>"
    ]);

    
    const templateTestPage = await AdminHelper.demoTemplate(page, template, templateID);

    await expect(templateTestPage.getByText("Test Company")).toBeVisible();
});