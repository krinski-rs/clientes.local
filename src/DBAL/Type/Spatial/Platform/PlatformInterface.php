<?php
namespace App\DBAL\Type\Spatial\Platform;

use App\DBAL\Type\Spatial\AbstractSpatialType;
use App\DBAL\PHP\Spatial\GeometryInterface;

interface PlatformInterface
{
    /**
     * @param AbstractSpatialType $objAbstractSpatialType
     * @param GeometryInterface   $value
     *
     * @return string
     */
    public function convertToDatabaseValue(AbstractSpatialType $objAbstractSpatialType, GeometryInterface $value);
    /**
     * @param AbstractSpatialType $objAbstractSpatialType
     * @param string              $sqlExpr
     *
     * @return string
     */
    public function convertToDatabaseValueSQL(AbstractSpatialType $objAbstractSpatialType, $sqlExpr);
    /**
     * @param AbstractSpatialType $objAbstractSpatialType
     * @param string              $sqlExpr
     *
     * @return string
     */
    public function convertToPHPValueSQL(AbstractSpatialType $objAbstractSpatialType, $sqlExpr);
    
    /**
     *
     * @param array $fieldDeclaration
     *
     * @return string
     */
    public function getSQLDeclaration(array $fieldDeclaration);
    
    /**
     * @param AbstractSpatialType $objAbstractSpatialType
     *
     * @return string
     */
    public function getMappedDatabaseTypes(AbstractSpatialType $objAbstractSpatialType);
}
