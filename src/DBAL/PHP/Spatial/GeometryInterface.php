<?php
namespace App\DBAL\PHP\Spatial;

/*
 * @author  Reinaldo Krinski <reinaldo.krinski@gmail.com>
 */

interface GeometryInterface
{
    
    const GEOMETRY           = 'Geometry';
    const POINT              = 'Point';
    const LINESTRING         = 'LineString';
    const POLYGON            = 'Polygon';
    const MULTIPOINT         = 'MultiPoint';
    const MULTILINESTRING    = 'MultiLineString';
    const MULTIPOLYGON       = 'MultiPolygon';
    const GEOMETRYCOLLECTION = 'GeometryCollection';
    
    public function getType():string;
}
