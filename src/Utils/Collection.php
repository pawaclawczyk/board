<?php

declare (strict_types = 1);

namespace Utils;

final class Collection
{
    private $items;

    private function __construct(array $items)
    {
        $this->items = $items;
    }

    public static function of(array $items) : Collection
    {
        return new self($items);
    }

    public static function empty() : Collection
    {
        return self::of([]);
    }

    public function append($item) : Collection
    {
        return $this->concatenate(self::of($item));
    }

    public function concatenate(Collection $collection) : Collection
    {
        return self::of(array_merge([], ($this->items), $collection->items));
    }

    public function filter(callable $filter) : Collection
    {
        return self::of(array_filter($this->items, $filter));
    }

    public function head()
    {
        return reset($this->items);
    }
}
