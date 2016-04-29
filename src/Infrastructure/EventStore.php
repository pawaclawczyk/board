<?php

declare (strict_types = 1);

namespace Infrastructure;

use Utils\Collection;

final class EventStore
{
    /** @var Collection[] */
    private $streams = [];

    public function createStream(string $streamName)
    {
        $this->streams[$streamName] = Collection::empty();
    }

    public function push(string $streamName, Collection $events)
    {
        $this->streams[$streamName] = $this->streams[$streamName]->concatenate($events);
    }

    public function pull(string $streamName) : Collection
    {
        return $this->streams[$streamName];
    }
}
