<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreEventRequest;
use App\Http\Requests\UpdateEventRequest;
use App\Http\Resources\EventResource;
use App\Models\Event;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Storage;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class EventController extends Controller
{
    public function index(): JsonResponse
    {
        $events = Event::orderBy('event_date')->paginate(10);
        return response()->json([
            'status' => 'success',
            'data' => EventResource::collection($events),
            'meta' => [
                'current_page' => $events->currentPage(),
                'per_page' => $events->perPage(),
                'total' => $events->total(),
                'last_page' => $events->lastPage(),
            ]
        ]);
    }

    public function show($id): JsonResponse
    {
        try {
            $event = Event::findOrFail($id);
            return response()->json([
                'status' => 'success',
                'data' => new EventResource($event)
            ]);
        } catch (ModelNotFoundException $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Event not found'
            ], 404);
        }
    }

    public function store(StoreEventRequest $request): JsonResponse
    {
        $data = $request->validated();

        if ($request->hasFile('image')) {
            $data['image_path'] = $request->file('image')->store('events', 'public');
        }

        $event = Event::create($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Event created successfully',
            'data' => new EventResource($event)
        ], 201);
    }

    public function update(UpdateEventRequest $request, $id): JsonResponse
    {
        try {
            $event = Event::findOrFail($id);
            $data = $request->validated();

            if ($request->hasFile('image')) {
                if ($event->image_path) {
                    Storage::disk('public')->delete($event->image_path);
                }
                $data['image_path'] = $request->file('image')->store('events', 'public');
            }

            $event->update($data);

            return response()->json([
                'status' => 'success',
                'message' => 'Event updated successfully',
                'data' => new EventResource($event)
            ]);
        } catch (ModelNotFoundException $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Event not found'
            ], 404);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $event = Event::findOrFail($id);
            
            if ($event->image_path) {
                Storage::disk('public')->delete($event->image_path);
            }

            $event->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Event deleted successfully'
            ]);
        } catch (ModelNotFoundException $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Event not found'
            ], 404);
        }
    }
}