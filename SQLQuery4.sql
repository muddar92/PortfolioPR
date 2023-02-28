SELECT location,date,total_cases,total_deaths ,(total_deaths/total_cases)*100 AS DeathPercentage
FROM ProtfolioProject..CovidDeaths
Where location like 'United Kingdom'
Order by 1,2

SELECT location,date,population,total_cases,(total_cases/population)*100 AS Percentagetopopulation
FROM ProtfolioProject..CovidDeaths
Where location = 'United Kingdom'
Order by 1,2



Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(New_Cases)*100 as DeathPercentage
From ProtfolioProject..CovidDeaths
where continent is not null 
order by total_cases,total_deaths


SELECT  location, population,date, MAX(total_cases) AS Highest_Number_of_infected,MAX(total_cases / population) * 100 AS Percentageof_infected
FROM  ProtfolioProject..CovidDeaths
WHERE location not in ( 'World' , 'High income','Europe','Asia','European Union','Upper middle income','Upper middle income',
'North America','Lower middle income','Low income','South America','Africa','Asia') and population is not null
GROUP BY  location, population,date
ORDER BY  Percentageof_infected 

SELECT location, MAX(CAST(total_deaths AS int)) AS DeathPerCountry
FROM ProtfolioProject..CovidDeaths
Where continent is not Null
GROUP BY location
ORDER BY DeathPerCountry DESC

SELECT continent, MAX(CAST(total_deaths AS int)) AS Totaldeathcount
FROM ProtfolioProject..CovidDeaths
Where continent is not Null
GROUP BY continent
ORDER BY Totaldeathcount DESC





WITH PopOverVac(date,population,location,tot)
AS (
  SELECT dea.date,dea.population,dea.location, MAX(CAST(total_vaccinations AS bigint)) AS tot
  FROM ProtfolioProject..CovidDeaths AS dea
  JOIN ProtfolioProject..CovidVaccinations AS vac ON dea.location = vac.location
  GROUP BY dea.location,dea.population,dea.date
)
SELECT date,population, location, tot/population * 100 AS Vac_to_pop_percentage
--CASE WHEN tot = 0 THEN NULL ELSE CAST(population AS FLOAT)/tot    END AS Vac_to_pop_percentage
FROM PopOverVac
order by Vac_to_pop_percentage DESC




WITH PopOverVac(date,population,location,tot)
AS (
  SELECT dea.date,dea.population,dea.location, MAX(CAST(total_vaccinations AS bigint)) AS tot
  FROM ProtfolioProject..CovidDeaths AS dea
  JOIN ProtfolioProject..CovidVaccinations AS vac ON dea.location = vac.location
  GROUP BY dea.location,dea.population,dea.date
)
SELECT date,population, location, tot/population * 100 AS Vac_to_pop_percentage
--CASE WHEN tot = 0 THEN NULL ELSE CAST(population AS FLOAT)/tot    END AS Vac_to_pop_percentage
FROM PopOverVac
order by Vac_to_pop_percentage DESC


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProtfolioProject..CovidDeaths dea
Join ProtfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 