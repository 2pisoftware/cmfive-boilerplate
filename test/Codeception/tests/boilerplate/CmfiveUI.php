<?php
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
  	public function fillForm($data) {
			if (is_array($data)) {
					foreach ($data as $fieldName=>$fieldValue) {
							$fieldNameParts=explode(':',$fieldName);
							if ($fieldNameParts[0]=='check' && count($fieldNameParts)>1) {
									if ($fieldValue) {
											 $this->checkOption('#'.$fieldNameParts[1]);
									} else {
											$this->uncheckOption('#'.$fieldNameParts[1]);
									}
							} else if (($fieldNameParts[0]=='select' || $fieldNameParts[0]=='radio') && count($fieldNameParts)>1) {
									$this->selectOption('#'.$fieldNameParts[1] ,$fieldValue);
							} else if ($fieldNameParts[0]=='date' && count($fieldNameParts)>1) {
									$this->fillDatePicker($fieldNameParts[1],$fieldValue);
							} else if ($fieldNameParts[0]=='datetime' && count($fieldNameParts)>1) {
									$this->fillDateTimePicker($fieldNameParts[1],$fieldValue);
							} else if ($fieldNameParts[0]=='time' && count($fieldNameParts)>1) {
									$this->fillTimePicker($fieldNameParts[1],$fieldValue);
							} else if ($fieldNameParts[0]=='rte' && count($fieldNameParts)>1) {
									$this->fillCkEditorById($fieldNameParts[1],$fieldValue);
							} else if ($fieldNameParts[0]=='autocomplete' && count($fieldNameParts)>1) {
									$this->fillAutocomplete($fieldNameParts[1],$fieldValue);
							} else {
									$this->fillField('#'.$fieldName ,$fieldValue);
							}
					}
			}
	}

public function findTableRowMatching($columnNumber,$matchValue) {
			$rows=$this->grabMultiple('.tablesorter tbody tr td:nth-child('.$columnNumber.')');
			if (is_array($rows))  {
					foreach ($rows as  $k=>$v) {
							$thisndex=$k + 1;
							if (trim($v)==trim($matchValue)) {
									return $thisndex;
							}
					}
			}
			return false;
	}

/*******************************************************
 * http://stackoverflow.com/questions/29168107/how-to-fill-a-rich-text-editor-field-for-a-codeception-acceptance-test
 *******************************************************/
 public function fillCkEditorById($element_id, $content) {
				$this->fillRteEditor(\Facebook\WebDriver\WebDriverBy::cssSelector(
								'#cke_' . $element_id . ' .cke_wysiwyg_frame'
						),
						$content
				);
		}

		public function fillCkEditorByName($element_name, $content) {
				$this->fillRteEditor(\Facebook\WebDriver\WebDriverBy::cssSelector(
								'textarea[name="' . $element_name . '"] + .cke .cke_wysiwyg_frame'
						),
						$content
				);
		}
		public  function fillRteEditor($selector, $content) {
				$this->executeInSelenium(
						function (\Facebook\WebDriver\Remote\RemoteWebDriver $webDriver)
						use ($selector, $content) {
								$webDriver->switchTo()->frame(
										$webDriver->findElement($selector)
								);

								$webDriver->executeScript(
										'arguments[0].innerHTML = "' . addslashes($content) . '"',
										[$webDriver->findElement(\Facebook\WebDriver\WebDriverBy::tagName('body'))]
								);

								$webDriver->switchTo()->defaultContent();
						});
		}

		public function fillDatePicker($field,$date) {
				$day=date('j',$date);
				$month=date('M',$date);
				$year=date('Y',$date);
				$hour=date('H',$date);
				$dateFormatted=date('d/m/Y H:i',$date);
				$finalDateFormatted=date('d/m/Y',$date);
				$this->executeJS('return $("#'.$field.'").datepicker("setDate","'.$dateFormatted.'");');
				$this->seeInField('#'.$field,$finalDateFormatted);
		}

		public function fillDateTimePicker($field,$date) {
				$day=date('j',$date);
				$month=date('M',$date);
				$year=date('Y',$date);
				$hour=date('H',$date);
				$dateFormatted=date('d/m/Y H:i',$date);
				$finalDateTimeFormatted=date('d/m/Y h:i a',$date);
				$this->executeJS('return $("#'.$field.'").datepicker("setDate","'.$dateFormatted.'");');
				$this->seeInField('#'.$field,$finalDateTimeFormatted);
		}

		public function fillTimePicker($field,$date) {
				$day=date('j',$date);
				$month=date('M',$date);
				$year=date('Y',$date);
				$hour=date('H',$date);
				$dateFormatted=date('d/m/Y H:i',$date);
				$finalTimeFormatted=date('h:i a',$date);
				$this->executeJS('return $("#'.$field.'").datepicker("setDate","'.$dateFormatted.'");');
				$this->seeInField('#'.$field,$finalTimeFormatted);
		}

		public function fillAutocomplete($field,$value) {
		//	echo "<pre>"; var_dump('wooah autocomplete'); die;
				$this->fillField("#".$field,$value);
				$this->waitForElement("#acp_".$field,2);
				// down
				$this->pressKey("#acp_".$field,"\xEE\x80\x95");
				// select
				$this->executeJS('$("#acp_".$field).show(); $("#acp_".$field).click();');
		}


}
