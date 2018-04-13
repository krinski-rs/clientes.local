<?php
namespace App\DBAL\PHP\Spatial;

/*
 * @author  Reinaldo Krinski <reinaldo.krinski@gmail.com>
 */

abstract class AbstractPoint extends AbstractGeometry
{
    /**
     * @var float $x
     */
    protected $x;
    
    /**
     * @var float $y
     */
    protected $y;
    
    public function __construct(float $x, float $y, int $srid = NULL)
    {
        $this->x = $x;
        $this->y = $y;
        $this->srid = $srid;
    }
    
    /**
     * @param float $x
     *
     * @return self
     */
    public function setX(float $x)
    {
        $this->x = $x;
        return $this;
    }
    
    /**
     * @return float
     */
    public function getX()
    {
        return $this->x;
    }
    
    /**
     * @param float $y
     *
     * @return self
     */
    public function setY(float $y)
    {
        $this->y = $y;
        return $this;
    }
    
    /**
     * @return float
     */
    public function getY()
    {
        return $this->y;
    }
    
    /**
     * @param float $latitude
     *
     * @return self
     */
    public function setLatitude(float $latitude)
    {
        return $this->setY($latitude);
    }
    
    /**
     * @return float
     */
    public function getLatitude()
    {
        return $this->getY();
    }
    
    /**
     * @param float $longitude
     *
     * @return self
     */
    public function setLongitude(float $longitude)
    {
        return $this->setX($longitude);
    }
    
    /**
     * @return float
     */
    public function getLongitude()
    {
        return $this->getX();
    }
    
    /**
     * @return string
     */
    public function getType():string
    {
        return self::POINT;
    }
    
    /**
     * @return array
     */
    public function toArray():array
    {
        return [$this->x, $this->y, $this->srid];
    }
}