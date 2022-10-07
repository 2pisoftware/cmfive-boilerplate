<?php

class TwoProduct extends DbObject
{
    public $name; // "Produktname"
    public $sku; // "Produkt-SKU
    public $code; // "Produkt-ID

    public $description;
    public $stock; // how many in stock?
    public $type; // manufactured, imported, hybrid

    public $is_deprecated;

    public $category;
    public $subcategory;

    public function getCategories() {
        return $this->sql("select distinct category from two_product where is_deleted = 0 order by category asc");
    }

    public function getSubCategories() {
        return $this->sql("select distinct subcategory from two_product where is_deleted = 0 order by subcategory asc");
    }

    public function fillFromWeeblyCsvRow($row)
    {
        $this->code = $row["Produkt-ID"];
        $this->sku = $row["Produkt-SKU"];
        $this->name = $row["Produktname"];
    }
}
