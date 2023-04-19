import { expect, test } from "@playwright/test";
import { GLOBAL_TIMEOUT, CmfiveHelper } from "./cmfive.helper";
import { AdminHelper} from "./admin.helper";

test.describe.configure({mode: 'parallel'});

test("Test that an admin can create and delete a user", async ({ page }) => {
    test.setTimeout(GLOBAL_TIMEOUT);

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
    await AdminHelper.createUserGroup(page, parentgroup);
    await AdminHelper.createUserGroup(page, usergroup);
    await AdminHelper.addUserGroupMember(page, parentgroup, usergroup.toUpperCase());
    await AdminHelper.addUserGroupMember(page, usergroup, user+"_firstName " + user+"_lastName");
    
    await AdminHelper.editUserGroupPermissions(page, usergroup, ["user", "comment"]);
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


// /**
//  * Cannot edit user Titles?
//  */
// test("Test that Cmfive Admin handles lookups", async ({ page }) => {
//     test.setTimeout(GLOBAL_TIMEOUT);

//     await CmfiveHelper.login(page, "admin", "admin");
    
//     const user = CmfiveHelper.randomID("user_");
//     await AdminHelper.createUser(
//         page,
//         user,
//         user+"_password",
//         user+"_firstName",
//         user+"_lastName",
//         user+"@localhost.com"
//     );

//     await AdminHelper.editUser(page, user, [["Title", "Prime Minister"]]);
//     await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Lookup");
//     await expect(page.getByText("Prime Minister")).toBeVisible();

//     await AdminHelper.editLookup(page, "Prime Minister", {"Title": "President"});
//     await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "List Users");
//     await CmfiveHelper.getRowByText(page, user).getByRole("button", {name: "Edit"}).click();
//     await expect(page.getByText("President")).toBeVisible();

//     await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Lookup");
//     await AdminHelper.deleteLookup(page, "President");
//     await expect(page.getByText("Cannot delete lookup as it is used as a title for the contacts: " + user+"_firstName " + user+"_lastName")).toBeVisible();

//     await AdminHelper.createLookup(page, "title", "The Honerable", "The Honerable");
//     await expect(page.getByText("The Honerable").first()).toBeVisible();

//     await AdminHelper.editUser(page, user, [["Title", "The Honerable"]]);
//     await CmfiveHelper.clickCmfiveNavbar(page, "Admin", "Lookup");
//     await AdminHelper.deleteLookup(page, "President");
//     await expect(page.getByText("Lookup Item deleted")).toBeVisible();

//     await AdminHelper.deleteUser(page, user);
//     await AdminHelper.deleteLookup(page, "The Honerable");
//     await expect(page.getByText("Lookup Item deleted")).toBeVisible();
// });

/**
 * How to check that rendertemplate page opened?
 * How to check that rendertemplate page has specific content?
 */
test("Test that Cmfive Admin handles templates", async ({ page }) => {
    test.setTimeout(GLOBAL_TIMEOUT);

    await CmfiveHelper.login(page, "admin", "admin");
    
    const template = CmfiveHelper.randomID("template_");
    await AdminHelper.createTemplate(page, template, "Admin", "Templates", [
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

    
    const templateTestPage = await AdminHelper.demoTemplate(page, template);

    await expect(templateTestPage.getByText("Test Company")).toBeVisible();
});