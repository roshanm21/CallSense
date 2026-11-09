type SearchResult = {
  title?: string;
  url?: string;
  content?: string;
};

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (request: Request): Promise<Response> => {
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (request.method !== "POST") {
    return jsonResponse({ error: "Method not allowed." }, 405);
  }

  let payload: unknown;
  try {
    payload = await request.json();
  } catch {
    return jsonResponse({ error: "Request body must be valid JSON." }, 400);
  }

  const companyName =
    payload && typeof payload === "object" && "companyName" in payload
      ? (payload as { companyName?: unknown }).companyName
      : null;
  if (
    typeof companyName !== "string" ||
    companyName.trim().length < 2 ||
    companyName.trim().length > 120
  ) {
    return jsonResponse(
      { error: "companyName must contain between 2 and 120 characters." },
      400,
    );
  }

  const apiKey = Deno.env.get("TAVILY_API_KEY");
  if (!apiKey) {
    return jsonResponse({ error: "Company search is not configured." }, 503);
  }

  let searchResponse: Response;
  try {
    searchResponse = await fetch("https://api.tavily.com/search", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({
        api_key: apiKey,
        query: `${companyName.trim()} official website company`,
        search_depth: "basic",
        max_results: 5,
      }),
    });
  } catch {
    return jsonResponse({ error: "Company search is temporarily unavailable." }, 502);
  }
  if (!searchResponse.ok) {
    return jsonResponse({ error: "Company search provider returned an error." }, 502);
  }

  const searchData: unknown = await searchResponse.json();
  const rawResults =
    searchData && typeof searchData === "object" && "results" in searchData
      ? (searchData as { results?: unknown }).results
      : null;
  const results: SearchResult[] = Array.isArray(rawResults)
    ? rawResults.filter(
        (item): item is SearchResult =>
          typeof item === "object" && item !== null,
      )
    : [];
  const sources = results
    .map((item) => item.url)
    .filter((url): url is string => typeof url === "string")
    .slice(0, 5);
  const summary = results.length
    ? results
        .slice(0, 3)
        .map((item) => `${item.title ?? "Search result"}: ${item.content ?? ""}`)
        .join("\n\n")
    : "No search results were returned. Try another spelling or check independently.";

  const domain = firstDomain(sources);
  const domainAgeYears = domain ? await lookupDomainAge(domain) : null;
  return jsonResponse({
    companyName: companyName.trim(),
    summary,
    sources,
    domain,
    domainAgeYears,
  });
});

function firstDomain(urls: string[]): string | null {
  for (const value of urls) {
    try {
      const hostname = new URL(value).hostname;
      if (hostname && !hostname.endsWith(".gov") && !hostname.endsWith(".edu")) {
        return hostname;
      }
    } catch {
      continue;
    }
  }
  return null;
}

async function lookupDomainAge(domain: string): Promise<number | null> {
  let response: Response;
  try {
    response = await fetch(`https://rdap.org/domain/${encodeURIComponent(domain)}`);
  } catch {
    return null;
  }
  if (!response.ok) return null;

  const data: unknown = await response.json();
  if (!data || typeof data !== "object" || !("events" in data)) return null;
  const events = (data as { events?: unknown }).events;
  if (!Array.isArray(events)) return null;

  const registration = events.find(
    (event) =>
      typeof event === "object" &&
      event !== null &&
      "eventAction" in event &&
      event.eventAction === "registration",
  );
  if (!registration || typeof registration !== "object" || !("eventDate" in registration)) {
    return null;
  }
  const registeredAt = new Date(String(registration.eventDate));
  if (Number.isNaN(registeredAt.getTime())) return null;
  return Math.max(
    0,
    Math.floor((Date.now() - registeredAt.getTime()) / (365.25 * 24 * 60 * 60 * 1000)),
  );
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "content-type": "application/json" },
  });
}
