<?php
namespace App\DBAL\Type\Spatial\Platform;

use App\DBAL\Type\Spatial\AbstractSpatialType;
use App\DBAL\PHP\Spatial\GeometryInterface;
use App\DBAL\Type\Spatial\GeographyType;

abstract class AbstractPlatform implements PlatformInterface
{
    /**
     * @param AbstractSpatialType $type
     * @param GeometryInterface   $value
     *
     * @return string
     */
    public function convertToDatabaseValue(AbstractSpatialType $type, GeometryInterface $value)
    {
        return sprintf('%s(%s)', strtoupper($value->getType()), $value);
    }
    
    /**
     *
     * @param AbstractSpatialType $type
     *
     * @return string[]
     */
    public function getMappedDatabaseTypes(AbstractSpatialType $type)
    {
        $sqlType = strtolower($type->getSQLType());
        if ($type instanceof GeographyType && $sqlType !== 'geography') {
            $sqlType = sprintf('geography(%s)', $sqlType);
        }
        return array($sqlType);
    }
    
    /**
     * Create spatial object from parsed value
     *
     * @param AbstractSpatialType $type
     * @param array               $value
     *
     * @return GeometryInterface
     * @throws \RuntimeException
     */
    private function newObjectFromValue(AbstractSpatialType $type, $value)
    {
        $typeFamily = $type->getTypeFamily();
        $typeName   = strtoupper($value['type']);
        $constName = sprintf('CrEOF\Spatial\PHP\Types\Geometry\GeometryInterface::%s', $typeName);
        if (! defined($constName)) {
            throw new \RuntimeException(sprintf('Unsupported %s type "%s".', $typeFamily, $typeName));
        }
        $class = sprintf('CrEOF\Spatial\PHP\Types\%s\%s', $typeFamily, constant($constName));
        return new $class($value['value'], $value['srid']);
    }
}
