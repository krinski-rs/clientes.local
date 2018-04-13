<?php
namespace App\DBAL\Type\Spatial;

use Doctrine\DBAL\Types\Type;
use Doctrine\DBAL\Platforms\AbstractPlatform;
use App\DBAL\Type\Spatial\Platform\PlatformInterface;

/*
 * @author  Reinaldo Krinski <reinaldo.krinski@gmail.com>
 */

class AbstractSpatialType extends Type
{
    const PLATFORM_POSTGRESQL = 'PostgreSql';
    
    /**
     *
     * @return string
     */
    public function getName()
    {
        return array_search(get_class($this), self::getTypesMap(), true);
    }

    public function getSQLDeclaration(array $fieldDeclaration, AbstractPlatform $objAbstractPlatform):string
    {
        return $this->getSpatialPlatform($objAbstractPlatform)->getSQLDeclaration($fieldDeclaration);
    }
    
    public function canRequireSQLConversion()
    {
        return TRUE;
    }
    
    /**
     *
     * @param AbstractPlatform AbstractPlatform
     *
     * @return bool
     */
    public function requiresSQLCommentHint(AbstractPlatform $objAbstractPlatform)
    {
        // TODO onSchemaColumnDefinition event listener?
        return true;
    }
    
    /**
     * @param AbstractPlatform $objAbstractPlatform
     *
     * @return PlatformInterface
     * @throws \RuntimeException
     */
    private function getSpatialPlatform(AbstractPlatform $objAbstractPlatform)
    {
        $const = sprintf('self::PLATFORM_%s', strtoupper($objAbstractPlatform->getName()));
        if (! defined($const)) {
            throw new \RuntimeException(sprintf('DBAL platform "%s" is not currently supported.', $objAbstractPlatform->getName()));
        }
        $class = sprintf('App\DBAL\Type\Spatial\Platform\%s', constant($const));
        return new $class;
    }
}

