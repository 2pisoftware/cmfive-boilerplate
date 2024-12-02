import { expect, test } from "@playwright/test";
import { GLOBAL_TIMEOUT, CmfiveHelper } from "@utils/cmfive";

test.describe.configure({mode: 'parallel'});

test("that hello is world", async ({ page }) => {
    test.setTimeout(GLOBAL_TIMEOUT);
    CmfiveHelper.acceptDialog(page);

    await CmfiveHelper.login(page, "admin", "admin");

    expect("hello").toEqual("world");
});