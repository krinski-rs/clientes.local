<?php
namespace App\DBAL\Type\Spatial\Platform;

use App\DBAL\Type\Spatial\AbstractSpatialType;
use App\DBAL\PHP\Spatial\GeometryInterface;
use App\DBAL\Type\Spatial\GeographyType;

class PostgreSql extends AbstractPlatform
{
    const DEFAULT_SRID = 4326;
    
    /**
     * @param AbstractSpatialType $type
     * @param string              $sqlExpr
     *
     * @return string
     */
    public function convertToPHPValueSQL(AbstractSpatialType $type, $sqlExpr)
    {
        if ($type instanceof GeographyType) {
            return sprintf('ST_AsEWKT(%s)', $sqlExpr);
        }
        return sprintf('ST_AsEWKB(%s)', $sqlExpr);
    }
    
    /**
     * @param AbstractSpatialType $type
     * @param string              $sqlExpr
     *
     * @return string
     */
    public function convertToDatabaseValueSQL(AbstractSpatialType $type, $sqlExpr)
    {
        if ($type instanceof GeographyType) {
            return sprintf('ST_GeographyFromText(%s)', $sqlExpr);
        }
        return sprintf('ST_GeomFromEWKT(%s)', $sqlExpr);
    }
    
    /**
     * @param AbstractSpatialType $type
     * @param string              $sqlExpr
     *
     * @return GeometryInterface
     * @throws \RuntimeException
     */
    public function convertBinaryToPHPValue(AbstractSpatialType $type, $sqlExpr)
    {
        if (! is_resource($sqlExpr)) {
            throw new \RuntimeException(sprintf('Invalid resource value "%s"', $sqlExpr));
        }
        $sqlExpr = stream_get_contents($sqlExpr);
        return parent::convertBinaryToPHPValue($type, $sqlExpr);
    }
    
    /**
     * @param AbstractSpatialType $type
     * @param GeometryInterface   $value
     *
     * @return string
     */
    public function convertToDatabaseValue(AbstractSpatialType $type, GeometryInterface $value)
    {
        $sridSQL = null;
        if ($type instanceof GeographyType && null === $value->getSrid()) {
            $value->setSrid(self::DEFAULT_SRID);
        }
        
        if (($srid = $value->getSrid()) !== null || $type instanceof GeographyType) {
            $sridSQL = sprintf('SRID=%d;', $srid);
        }
        return sprintf('%s%s', $sridSQL, parent::convertToDatabaseValue($type, $value));
    }
    
    /**
     *
     * @param array $fieldDeclaration
     *
     * @return string
     */
    public function getSQLDeclaration(array $fieldDeclaration)
    {
        $typeFamily = $fieldDeclaration['type']->getTypeFamily();
        $sqlType    = $fieldDeclaration['type']->getSQLType();
        if ($typeFamily === $sqlType) {
            return $sqlType;
        }
        if (isset($fieldDeclaration['srid'])) {
            return sprintf('%s(%s,%d)', $typeFamily, $sqlType, $fieldDeclaration['srid']);
        }
        return sprintf('%s(%s)', $typeFamily, $sqlType);
    }
}
