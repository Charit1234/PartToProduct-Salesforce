public with sharing class PartToProductService {

    public static void syncPartsWithProducts(List<SQX_Part__c> parts) {
        Set<String> partNumbers = new Set<String>();
        Set<String> partNames = new Set<String>();

        for (SQX_Part__c p : parts) {
            if (String.isNotBlank(p.Part_Number__c) && String.isNotBlank(p.Name)) {
                partNumbers.add(p.Part_Number__c);
                partNames.add(p.Name);
            }
        }

        Map<String, Product2> existingProducts = new Map<String, Product2>();
        for (Product2 prod : [
            SELECT Id, Name, ProductCode
            FROM Product2
            WHERE ProductCode IN :partNumbers OR Name IN :partNames
        ]) {
            existingProducts.put(prod.ProductCode + '|' + prod.Name, prod);
        }

        List<Product2> productsToInsert = new List<Product2>();
        List<SQX_Part__c> partsToUpdate = new List<SQX_Part__c>();

        for (SQX_Part__c p : parts) {
            if (p.Product2__c == null) {
                String key = p.Part_Number__c + '|' + p.Name;
                if (existingProducts.containsKey(key)) {
                    p.Product2__c = existingProducts.get(key).Id;
                } else {
                    Product2 newProd = new Product2(
                        Name = p.Name,
                        ProductCode = p.Part_Number__c,
                        IsActive = true
                    );
                    productsToInsert.add(newProd);
                }
                partsToUpdate.add(p);
            }
        }

        if (!productsToInsert.isEmpty()) {
            insert productsToInsert;
            Integer i = 0;
            for (SQX_Part__c p : partsToUpdate) {
                if (p.Product2__c == null && i < productsToInsert.size()) {
                    p.Product2__c = productsToInsert[i].Id;
                    i++;
                }
            }
        }

        if (!partsToUpdate.isEmpty()) {
            update partsToUpdate;
        }
    }
}