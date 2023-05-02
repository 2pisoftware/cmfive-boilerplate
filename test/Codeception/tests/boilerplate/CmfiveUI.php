<?php

namespace Tests\Support;

/**
 * Inherited Methods
 * @method void wantToTest($text)
 * @method void wantTo($text)
 * @method void execute($callable)
 * @method void expectTo($prediction)
 * @method void expect($prediction)
 * @method void amGoingTo($argumentation)
 * @method void am($role)
 * @method void lookForwardTo($achieveValue)
 * @method void comment($description)
 * @method \Codeception\Lib\Friend haveFriend($name, $actorClass = NULL)
 *
 * @SuppressWarnings(PHPMD)
 */
class CmfiveUI extends \Codeception\Actor
{
    use _generated\CmfiveUIActions;

    /**
     * Fill a form from an array of data
     * Assume that id attribute of form inputs match $data keys
     * where key starts with check: or select: a modified key is used
     * with the setOption or checkOption commands to set values
     * otherwise the input is treated as text using fillField
     */
    public function fillForm($data)
    {
        if (is_array($data)) {
            foreach ($data as $fieldName => $fieldValue) {
                $fieldNameParts = explode(':', $fieldName);
                if ($fieldNameParts[0] == 'check' && count($fieldNameParts) > 1) {
                    if ($fieldValue) {
                        $this->checkOption('#' . $fieldNameParts[1]);
                    } else {
                        $this->uncheckOption('#' . $fieldNameParts[1]);
                    }
                } elseif (($fieldNameParts[0] == 'select' || $fieldNameParts[0] == 'radio') && count($fieldNameParts) > 1) {
                    $this->wait(1);
                    $this->waitForElement('#' . $fieldNameParts[1], 2);
                    $this->wait(1);
                    $this->waitForElement('#' . $fieldNameParts[1], 2);
                    //$this->click("//select[@id='{$fieldNameParts[1]}']");
                    $this->selectOption('#' . $fieldNameParts[1], $fieldValue);
                    // add a moment for response scripts to kick
                    $this->wait(1);
                } elseif ($fieldNameParts[0] == 'date' && count($fieldNameParts) > 1) {
                    $this->fillDatePicker($fieldNameParts[1], $fieldValue);
                } elseif ($fieldNameParts[0] == 'datetime' && count($fieldNameParts) > 1) {
                    $this->fillDateTimePicker($fieldNameParts[1], $fieldValue);
                } elseif ($fieldNameParts[0] == 'time' && count($fieldNameParts) > 1) {
                    $this->fillTimePicker($fieldNameParts[1], $fieldValue);
                } elseif ($fieldNameParts[0] == 'rte' && count($fieldNameParts) > 1) {
                    $this->fillCkEditorById($fieldNameParts[1], $fieldValue);
                } elseif ($fieldNameParts[0] == 'autocomplete' && count($fieldNameParts) > 1) {
                    $this->fillAutocomplete($fieldNameParts[1], $fieldValue);
                } elseif ($fieldNameParts[0] == 'vModelAutocomplete' && count($fieldNameParts) > 1) {
                    $this->wait(1);
                    $this->waitForElement("(//div[@id = '".$fieldNameParts[1]."'])/input", 2);
                    $this->fillField("(//div[@id = '".$fieldNameParts[1]."'])/input", $fieldValue);
                } else {
                    $this->fillField('#' . $fieldName, $fieldValue);
                }
            }
        }
    }

    public function findTableRowMatching($columnNumber, $matchValue)
    {
        if ($this->isUsingBootstrap5($this)) {
            $rows = $this->grabMultiple('.table-responsive ul li:nth-child(' . $columnNumber . ')');
            if (count($rows) == 0) {
                $rows = $this->grabMultiple(".table-responsive table tbody tr td:nth-child(" . $columnNumber . ")");
            }
            if (count($rows) == 0) {
                $rows = $this->grabMultiple(".tablesorter tbody tr td:nth-child(" . $columnNumber . ")");
            }
            if (is_array($rows)) {
                foreach ($rows as $k => $v) {
                    if (trim($v) == trim($matchValue)) {
                        return $k + 1;
                    }
                }
            }
            return false;
        } else {
            $rows = $this->grabMultiple('.tablesorter tbody tr td:nth-child(' . $columnNumber . ')');
            if (count($rows) == 0) { // but what if it was a resized non-sorting table??
                $rows = $this->grabMultiple("//table/tbody/tr/td[" . $columnNumber . "]");
            }
            if (is_array($rows)) {
                foreach ($rows as $k => $v) {
                    if (trim($v) == trim($matchValue)) {
                        return $k + 1;
                    }
                }
            }
            return false;
        }
    }

/*******************************************************
 * http://stackoverflow.com/questions/29168107/how-to-fill-a-rich-text-editor-field-for-a-codeception-acceptance-test
 *******************************************************/
    public function fillCkEditorById($element_id, $content)
    {
        $this->fillRteEditor(\Facebook\WebDriver\WebDriverBy::cssSelector(
            '#cke_' . $element_id . ' .cke_wysiwyg_frame'
        ), $content);
    }

    public function fillCkEditorByName($element_name, $content)
    {
        $this->fillRteEditor(\Facebook\WebDriver\WebDriverBy::cssSelector(
            'textarea[name="' . $element_name . '"] + .cke .cke_wysiwyg_frame'
        ), $content);
    }

    public function fillRteEditor($selector, $content)
    {
        $this->executeInSelenium(
            function (\Facebook\WebDriver\Remote\RemoteWebDriver $webDriver) use ($selector, $content) {
                $webDriver->wait(3);
                $webDriver->switchTo()->frame(
                    $webDriver->findElement($selector)
                );

                $webDriver->executeScript(
                    'arguments[0].innerHTML = "' . addslashes($content) . '"',
                    [$webDriver->findElement(\Facebook\WebDriver\WebDriverBy::tagName('body'))]
                );

                $webDriver->switchTo()->defaultContent();
            }
        );
    }

    public function fillDatePicker($field, $date)
    {
        $dateFormatted = date('d/m/Y H:i', $date);
        $finalDateFormatted = date('d/m/Y', $date);
        $this->executeJS('$("#' . $field . '").datepicker("setDate","' . $dateFormatted . '");');
        $this->wait(1);
        $this->seeInField('#' . $field, $finalDateFormatted);
    }

    public function fillDateTimePicker($field, $date)
    {
        $dateFormatted = date('d/m/Y H:i', $date);
        $finalDateTimeFormatted = date('d/m/Y h:i a', $date);
        $this->executeJS('$("#' . $field . '").datepicker("setDate","' . $dateFormatted . '");');
        $this->wait(1);
        $this->seeInField('#' . $field, $finalDateTimeFormatted);
    }

    public function fillTimePicker($field, $date)
    {
        $dateFormatted = date('d/m/Y H:i', $date);
        $finalTimeFormatted = date('h:i a', $date);
        $this->executeJS('$("#' . $field . '").datepicker("setDate","' . $dateFormatted . '");');
        $this->wait(1);
        $this->seeInField('#' . $field, $finalTimeFormatted);
    }

    public function fillAutocomplete($field, $value)
    {
        $this->executeJS("$('#acp_{$field}').autocomplete('search', '{$value}')");
        // pause & believe the UI entry exists
        $this->waitForText($value);
        //$this->click($value, '.ui-menu-item');
        // this way is more resilient regards 'focus' & timing?
        $this->click("//li[contains(@class,'ui-menu-item')]/a[contains(text(),'{$value}')]");
    }
}
