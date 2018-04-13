<?php
namespace App\DBAL\PHP\Spatial;

/*
 * @author  Reinaldo Krinski <reinaldo.krinski@gmail.com>
 */

abstract class AbstractGeometry implements GeometryInterface
{
    /**
     * @var int
     */
    protected $srid;
    
    /**
     * @return array
     */
    abstract public function toArray():array;
    
    /**
     * @return string
     */
    public function __toString():string
    {
        $type   = strtoupper($this->getType());
        $method = 'toString' . $type;
        return $this->$method($this->toArray());
    }
    
    /**
     * @return string
     */
    public function toJson():string
    {
        $json['type'] = $this->getType();
        $json['coordinates'] = $this->toArray();
        return json_encode($json);
    }
    
    /**
     * @return null|int
     */
    public function getSrid()
    {
        return $this->srid;
    }
    
    /**
     * @param int $srid
     *
     * @return self
     */
    public function setSrid(int $srid)
    {
        if ($srid !== null) {
            $this->srid = (int) $srid;
        }
        return $this;
    }
    
    /**
     * @param array $point
     *
     * @return string
     */
    private function toStringPoint(array $point)
    {
        return vsprintf('(%f,%f)', $point);
    }
    
    /**
     * @param array[] $multiPoint
     *
     * @return string
     */
    private function toStringMultiPoint(array $multiPoint)
    {
        $strings = array();
        foreach ($multiPoint as $point) {
            $strings[] = $this->toStringPoint($point);
        }
        return implode(',', $strings);
    }
    
    /**
     * @param array[] $lineString
     *
     * @return string
     */
    private function toStringLineString(array $lineString)
    {
        return $this->toStringMultiPoint($lineString);
    }
    
    /**
     * @param array[] $multiLineString
     *
     * @return string
     */
    private function toStringMultiLineString(array $multiLineString)
    {
        $strings = null;
        foreach ($multiLineString as $lineString) {
            $strings[] = '(' . $this->toStringLineString($lineString) . ')';
        }
        return implode(',', $strings);
    }
    
    /**
     * @param array[] $polygon
     *
     * @return string
     */
    private function toStringPolygon(array $polygon)
    {
        return $this->toStringMultiLineString($polygon);
    }
    
    /**
     * @param array[] $multiPolygon
     *
     * @return string
     */
    private function toStringMultiPolygon(array $multiPolygon)
    {
        $strings = null;
        foreach ($multiPolygon as $polygon) {
            $strings[] = '(' . $this->toStringPolygon($polygon) . ')';
        }
        return implode(',', $strings);
    }
}