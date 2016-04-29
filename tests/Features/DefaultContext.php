<?php

namespace Features;

use Assert\Assertion;
use Behat\Behat\Context\Context;
use Behat\Behat\Context\SnippetAcceptingContext;
use Board\PostWasPublished;
use Infrastructure\EventStore;
use Utils\Collection;

class DefaultContext implements Context, SnippetAcceptingContext
{
    private $eventStore;

    public function __construct()
    {
        $this->eventStore = new EventStore();
    }

    /**
     * @Given board named :boardName
     */
    public function boardNamed($boardName)
    {
        $this->eventStore->createStream($boardName);
    }

    /**
     * @When publish post on board :boardName with content :content
     */
    public function publishPostOnBoardWithContent($boardName, $content)
    {
        $this->eventStore->push($boardName, Collection::empty()->append(PostWasPublished::of($boardName, $content)));
    }

    /**
     * @Then post should be publish on board :boardName with content :content
     */
    public function postShouldBePublishOnBoardWithContent($boardName, $content)
    {
        $postWasPublished = function ($event) { return $event instanceof PostWasPublished; };

        $events = $this
            ->eventStore
            ->pull($boardName)
            ->filter($postWasPublished);

        Assertion::count($events, 1);
        Assertion::eq($events->head(), PostWasPublished::of($boardName, $content));
    }
}
