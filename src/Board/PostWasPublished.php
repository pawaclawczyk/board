<?php

declare (strict_types = 1);

namespace Board;

final class PostWasPublished
{
    public $board;
    public $content;

    private function __construct(string $board, string $content)
    {
        $this->board = $board;
        $this->content = $content;
    }

    public static function of(string $board, string $content) : PostWasPublished
    {
        return new self($board, $content);
    }
}
